//
//  CrossPaletteView.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

struct CrossPaletteView: View {
    let colors: [SanzoColor] // expects 4

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let rectW = w * 0.62
            let rectH = h * 0.22
            let gap = h * 0.06

            ZStack {
                block(colors[0])
                    .frame(width: rectW, height: rectH)
                    .offset(x: 0, y: -(rectH + gap) / 1.28)

                block(colors[1])
                    .frame(width: rectW, height: rectH)
                    .offset(x: -(rectW * 0.50), y: 0)

                block(colors[2])
                    .frame(width: rectW, height: rectH)
                    .offset(x: (rectW * 0.50), y: 0)

                block(colors[3])
                    .frame(width: rectW, height: rectH)
                    .offset(x: 0, y: (rectH + gap) / 1.28)
            }
            .frame(width: w, height: h)
        }
//        .background(Color(white: 0.96))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(.black.opacity(0.08), lineWidth: 1)
        )
    }

    private func block(_ c: SanzoColor) -> some View {
        Rectangle().fill(Color(hex: c.hex) ?? .clear)
    }
}


#Preview("CrossPaletteView") {
    CrossPaletteView(colors: PreviewData.crossColors)
        .frame(width: 420, height: 420)
        .padding(24)
}

private enum PreviewData {
    static var crossColors: [SanzoColor] {
        // Try to load from colors.json in the preview bundle
        if let url = Bundle.main.url(forResource: "colors", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let all = try? JSONDecoder().decode([SanzoColor].self, from: data) {

            // Build combo -> [SanzoColor]
            var bucket: [Int: [SanzoColor]] = [:]
            for c in all {
                for combo in c.combinations {
                    bucket[combo, default: []].append(c)
                }
            }

            // Pick the first combination with 4+ colours
            if let entry = bucket
                .sorted(by: { $0.key < $1.key })
                .first(where: { $0.value.count >= 4 }) {

                return Array(entry.value.prefix(4))
            }
        }

        // Fallback for preview stability
        return [
            SanzoColor(
                name: "Deep Slate Green",
                combinations: [1],
                swatch: 0,
                cmyk: [80, 60, 70, 50],
                lab: [0, 0, 0],
                rgb: [34, 45, 40],
                hex: "#222D28"
            ),
            SanzoColor(
                name: "Orange",
                combinations: [1],
                swatch: 1,
                cmyk: [0, 55, 95, 0],
                lab: [0, 0, 0],
                rgb: [240, 140, 50],
                hex: "#F08C32"
            ),
            SanzoColor(
                name: "Olive Ocher",
                combinations: [1],
                swatch: 2,
                cmyk: [10, 10, 70, 0],
                lab: [0, 0, 0],
                rgb: [210, 195, 60],
                hex: "#D2C33C"
            ),
            SanzoColor(
                name: "Warm Grey",
                combinations: [1],
                swatch: 3,
                cmyk: [0, 0, 0, 20],
                lab: [0, 0, 0],
                rgb: [200, 200, 200],
                hex: "#C8C8C8"
            )
        ]
    }
}
