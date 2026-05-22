//
//  FavouritesStore.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import Foundation

@MainActor
final class FavouritesStore: ObservableObject {
    private let key = "favourite_palette_ids_v1"

    @Published private(set) var ids: Set<Int> = []

    init() {
        load()
    }

    func isFavourite(_ id: Int) -> Bool {
        ids.contains(id)
    }

    func toggle(_ id: Int) {
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        if let decoded = try? JSONDecoder().decode([Int].self, from: data) {
            ids = Set(decoded)
        }
    }

    private func save() {
        let arr = Array(ids).sorted()
        let data = (try? JSONEncoder().encode(arr)) ?? Data()
        UserDefaults.standard.set(data, forKey: key)
    }
}
