//
//  PaletteGridView.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

struct PaletteGridView: View {
    @EnvironmentObject private var store: PaletteStore

    @State private var query = ""
    @State private var minColors = 4

    private var filtered: [PaletteStore.Palette] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return store.palettes.filter { palette in
            guard palette.colors.count >= minColors else { return false }
            guard !q.isEmpty else { return true }

            // Search: palette id, or any colour name/hex inside it
            if String(palette.id).contains(q) { return true }
            return palette.colors.contains { c in
                c.name.localizedCaseInsensitiveContains(q) || c.hex.localizedCaseInsensitiveContains(q)
            }
        }
    }

    private let cols = [
        GridItem(.adaptive(minimum: 170), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: cols, spacing: 12) {
                    ForEach(filtered) { palette in
                        NavigationLink {
                            PaletteDetailView(palette: palette)
                        } label: {
                            PaletteCard(palette: palette)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Colour Combinations")
            .searchable(text: $query, prompt: "Search name, hex, or combination id")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Stepper("Min colours: \(minColors)", value: $minColors, in: 2...12)
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
    }
}

private struct PaletteCard: View {
    let palette: PaletteStore.Palette

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("#\(palette.id)")
                    .font(.headline)
                Spacer()
                Text("\(palette.colors.count) colours")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Stripes preview
            VStack(spacing: 0) {
                ForEach(palette.colors.prefix(6), id: \.id) { c in
                    Rectangle()
                        .fill(Color(hex: c.hex) ?? .clear)
                        .frame(height: 14)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            // Small labels
            Text(palette.colors.prefix(2).map(\.name).joined(separator: " • "))
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(12)
        .background(.thinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.primary.opacity(0.12), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
