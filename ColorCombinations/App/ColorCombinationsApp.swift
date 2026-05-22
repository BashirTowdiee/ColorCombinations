//
//  ColorCombinationsApp.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

@main
struct ColorCombinationsApp: App {
    @StateObject private var store = PaletteStore()
    @StateObject private var favourites = FavouritesStore()
    @StateObject private var appearance = AppearanceStore()

    var body: some Scene {
        WindowGroup {
            LibraryView()
               .environmentObject(store)
               .environmentObject(favourites)
               .environmentObject(appearance)
               .preferredColorScheme(appearance.mode.scheme)
               .task { store.load() }
        }
    }
}
