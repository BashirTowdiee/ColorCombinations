//
//  SanzoColor.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

struct SanzoColor: Codable, Identifiable, Hashable {
    // Stable id derived from content so it stays consistent across launches
    var id: String { "\(name)|\(hex)" }

    let name: String
    let combinations: [Int]
    let swatch: Int
    let cmyk: [Int]
    let lab: [Double]
    let rgb: [Int]
    let hex: String
}
