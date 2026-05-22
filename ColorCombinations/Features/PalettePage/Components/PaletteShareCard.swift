//
//  PaletteShareCard.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

struct PaletteShareCard: View {
    let paletteId: Int
    let layout: PaletteLayout
    let colors: [SanzoColor]

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Combination #\(paletteId)")
                    .font(.system(.title3, design: .serif))
                    .fontWeight(.semibold)
                Spacer()
                Text("\(colors.count) colours")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            visual
                .frame(height: 480)
            
            labelsRow
        }
        .padding(18)
        .background(Color(white: 0.96))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.black.opacity(0.08), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    @ViewBuilder
    private var visual: some View {
        switch layout {
        case .strip:
            HStack(spacing: 0) {
                ForEach(colors, id: \.id) { c in
                    Rectangle()
                        .fill(Color(hex: c.hex) ?? .clear)
                        .frame(maxWidth: .infinity)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(.black.opacity(0.08), lineWidth: 1)
            )

        case .cross:
            if colors.count == 4 {
                CrossPaletteView(colors: colors)
                    .frame(width: 820, height: 820)
            } else {
                // Cross needs 4, fallback to strip
                HStack(spacing: 0) {
                    ForEach(colors, id: \.id) { c in
                        Rectangle()
                            .fill(Color(hex: c.hex) ?? .clear)
                            .frame(maxWidth: .infinity)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.black.opacity(0.08), lineWidth: 1)
                )
            }
        }
    }

    private var labelsRow: some View {
        HStack(alignment: .top, spacing: 12) {
            ForEach(colors, id: \.id) { c in
                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(hex: c.hex) ?? .clear)
                        .frame(width: 44, height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .strokeBorder(.black.opacity(0.10), lineWidth: 1)
                        )

                    Text(c.name)
                        .font(.system(.headline, design: .serif))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text(c.hex.uppercased())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
