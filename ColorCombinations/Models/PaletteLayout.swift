//
//  PaletteLayout.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import Foundation

enum PaletteLayout: String, CaseIterable, Identifiable {
    case strip = "Strip"
    case cross = "Cross"

    var id: String { rawValue }
}
