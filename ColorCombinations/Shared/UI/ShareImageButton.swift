//
//  ShareImageButton.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
struct ShareImageButton<Content: View>: View {
    let title: String
    let systemImage: String
    let paletteId: Int
    let content: Content

    @State private var pngData: Data?

    var body: some View {
        Group {
            if let pngData {
                ShareLink(
                    item: ShareablePNG(data: pngData),
                    preview: SharePreview("Combination #\(paletteId)")
                ) {
                    Label(title, systemImage: systemImage)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            } else {
                Button {
                    // no-op until rendered
                } label: {
                    Label(title, systemImage: systemImage)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(true)
                .task {
                    await render()
                }
            }
        }
    }

    @MainActor
    private func render() async {
        if let data = PlatformRenderer.renderPNG(
            content: content,
            size: CGSize(width: 1400, height: 900),
            scale: 2
        ) {
            self.pngData = data
        }
    }
}
