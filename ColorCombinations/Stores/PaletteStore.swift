//
//  PaletteStore.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import Foundation

@MainActor
final class PaletteStore: ObservableObject {
    @Published private(set) var colors: [SanzoColor] = []
    @Published private(set) var palettes: [Palette] = []

    struct Palette: Identifiable, Hashable {
        let id: Int                // combination id
        let colors: [SanzoColor]   // all colours that reference this id
    }

    func load() {
        do {
            guard let url = Bundle.main.url(forResource: "colors", withExtension: "json") else {
                assertionFailure("colors.json not found in bundle")
                return
            }
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([SanzoColor].self, from: data)

            colors = decoded

            // Build: combinationId -> [SanzoColor]
            var bucket: [Int: [SanzoColor]] = [:]
            for c in decoded {
                for combo in c.combinations {
                    bucket[combo, default: []].append(c)
                }
            }

            // Make it stable and pleasant:
            // - palettes sorted by id
            // - colours sorted by swatch then name
            palettes = bucket
                .map { (key, value) in
                    Palette(id: key, colors: value.sorted(by: {
                        if $0.swatch != $1.swatch { return $0.swatch < $1.swatch }
                        return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                    }))
                }
                .sorted(by: { $0.id < $1.id })


        } catch {
            assertionFailure("Failed loading colors.json: \(error)")
        }
    }
}
