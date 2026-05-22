//
//  PaletteDetailView.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

struct PaletteDetailView: View {
    let palette: PaletteStore.Palette

    var body: some View {
        List {
            Section {
                VStack(spacing: 0) {
                    ForEach(palette.colors, id: \.id) { c in
                        ColorRow(color: c)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } header: {
                Text("Combination #\(palette.id)")
            }

            Section("Export") {
                ShareLink(
                    item: exportText,
                    preview: SharePreview("Combination #\(palette.id)", image: Image(systemName: "paintpalette"))
                ) {
                    Label("Share as text", systemImage: "square.and.arrow.up")
                }

                Button {
                    UIPasteboard.general.string = exportText
                } label: {
                    Label("Copy to clipboard", systemImage: "doc.on.doc")
                }
            }
        }
        .navigationTitle("#\(palette.id)")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var exportText: String {
        palette.colors
            .map { "\($0.name) \($0.hex)" }
            .joined(separator: "\n")
    }
}

private struct ColorRow: View {
    let color: SanzoColor

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(hex: color.hex) ?? .clear)
                .frame(width: 56, height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(.primary.opacity(0.12), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(color.name)
                    .font(.subheadline)
                    .lineLimit(1)
                Text(color.hex.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                UIPasteboard.general.string = color.hex
            } label: {
                Image(systemName: "doc.on.doc")
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(.background.opacity(0.0001))
    }
}
