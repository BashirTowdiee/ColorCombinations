//
//  Platform+Share.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
import UIKit
typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
#endif

@available(iOS 16.0, macOS 13.0, *)
struct ShareablePNG: Transferable {
    let data: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.data
        }
    }
}

enum PlatformPasteboard {
    static func copy(_ string: String) {
        #if os(iOS)
        UIPasteboard.general.string = string
        #elseif os(macOS)
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(string, forType: .string)
        #endif
    }
}

enum PlatformRenderer {
    /// Renders a SwiftUI view to PNG data (iOS 16+/macOS 13+).
    @available(iOS 16.0, macOS 13.0, *)
    @MainActor
    static func renderPNG<V: View>(content: V, size: CGSize, scale: CGFloat = 2) -> Data? {
        let rendered = content.frame(width: size.width, height: size.height)

        let renderer = ImageRenderer(content: rendered)
        renderer.scale = scale

        #if os(iOS)
        return renderer.uiImage?.pngData()
        #elseif os(macOS)
        guard let nsImage = renderer.nsImage else { return nil }
        return nsImage.pngData()
        #endif
    }
}


#if os(macOS)
private extension NSImage {
    func pngData() -> Data? {
        guard
            let tiff = tiffRepresentation,
            let rep = NSBitmapImageRep(data: tiff)
        else { return nil }
        return rep.representation(using: .png, properties: [:])
    }
}
#endif
