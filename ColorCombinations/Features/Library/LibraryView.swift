//
//  LibraryView.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI
Apricot Orange  #F68C50
Lemon Yellow  #F8ED43
Cotinga Purple  #501345
Slate Color  #34454C
struct LibraryView: View {
    @EnvironmentObject private var store: PaletteStore
    @EnvironmentObject private var favourites: FavouritesStore

    @State private var query = ""
    @State private var showFavouritesOnly = false
    @State private var minColors = 4

    private var filtered: [PaletteStore.Palette] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)

        return store.palettes.filter { p in
            guard p.colors.count >= minColors else { return false }
            if showFavouritesOnly, !favourites.isFavourite(p.id) { return false }

            guard !q.isEmpty else { return true }
            if String(p.id).contains(q) { return true }
            return p.colors.contains { c in
                c.name.localizedCaseInsensitiveContains(q) || c.hex.localizedCaseInsensitiveContains(q)
            }
        }
    }

    private let cols = [GridItem(.adaptive(minimum: 170), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: cols, spacing: 12) {
                    ForEach(filtered) { palette in
                        NavigationLink {
                            PalettePagerView(palettes: filtered, startId: palette.id)
                        } label: {
                            LibraryCard(palette: palette, isFav: favourites.isFavourite(palette.id))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Combinations")
            .searchable(text: $query, prompt: "Search name, hex, or id")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Toggle(isOn: $showFavouritesOnly) {
                        Image(systemName: showFavouritesOnly ? "heart.fill" : "heart")
                    }
                    .toggleStyle(.button)
                    .buttonStyle(.plain)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 6) {
                        Button {
                            minColors = max(minColors - 1, 2)
                        } label: {
                            Image(systemName: "minus")
                        }

                        Text("\(minColors)")
                            .font(.title3)
                            .frame(minWidth: 24)

                        Button {
                            minColors = min(minColors + 1, 4)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        // start from a random palette in the current filter set
                        if let random = filtered.randomElement() {
                            PalettePagerView(palettes: filtered, startId: random.id)
                        } else {
                            Text("No palettes")
                        }
                    } label: {
                        Image(systemName: "shuffle")
                    }
                    .disabled(filtered.isEmpty)
                }
            }
        }
    }
}

private struct LibraryCard: View {
    let palette: PaletteStore.Palette
    let isFav: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("#\(palette.id)")
                    .font(.headline)
                Spacer()
                if isFav { Image(systemName: "heart.fill") }
            }

            VStack(spacing: 0) {
                ForEach(palette.colors.prefix(6), id: \.id) { c in
                    Rectangle()
                        .fill(Color(hex: c.hex) ?? .clear)
                        .frame(height: 14)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

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
