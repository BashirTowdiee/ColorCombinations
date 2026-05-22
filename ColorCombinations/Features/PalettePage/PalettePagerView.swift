//
//  PalettePagerView.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

struct PalettePagerView: View {
    @EnvironmentObject private var favourites: FavouritesStore
    @EnvironmentObject private var appearance: AppearanceStore

    let palettes: [PaletteStore.Palette]
    let startId: Int

    @State private var selection: Int = 0
    @State private var layout: PaletteLayout = .strip
    
    private func cycleAppearance() {
        switch appearance.mode {
        case .system:
            appearance.mode = .light
        case .light:
            appearance.mode = .dark
        case .dark:
            appearance.mode = .system
        }
    }


    var body: some View {
        TabView(selection: $selection) {
            ForEach(Array(palettes.enumerated()), id: \.offset) { idx, palette in
                PalettePageView(
                    palette: palette,
                    isFavourite: favourites.isFavourite(palette.id),
                    layout: layout,
                    onToggleFavourite: { favourites.toggle(palette.id) }
                )
                .tag(idx)
                .ignoresSafeArea()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            if let idx = palettes.firstIndex(where: { $0.id == startId }) {
                selection = idx
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Picker("Layout", selection: $layout) {
                    ForEach(PaletteLayout.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 180)

                Button {
                    let id = palettes[selection].id
                    favourites.toggle(id)
                } label: {
                    Image(systemName: favourites.isFavourite(palettes[selection].id) ? "heart.fill" : "heart")
                }
                
                Button {
                    cycleAppearance()
                } label: {
                    Image(systemName: appearance.mode.icon)
                }
                .accessibilityLabel("Toggle appearance")

                Button {
                    guard !palettes.isEmpty else { return }
                    selection = Int.random(in: 0..<palettes.count)
                } label: {
                    Image(systemName: "shuffle")
                }
                .disabled(palettes.isEmpty)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
