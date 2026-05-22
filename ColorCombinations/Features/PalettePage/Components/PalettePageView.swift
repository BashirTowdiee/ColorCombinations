//
//  PalettePagerView.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import SwiftUI

struct PalettePageView: View {
    @EnvironmentObject private var appearance: AppearanceStore

    let palette: PaletteStore.Palette
    let isFavourite: Bool
    let layout: PaletteLayout
    let onToggleFavourite: () -> Void

    @State private var copiedToast = false
    @State private var setIndex: Int = 0

    private let setSize = 4

    private var sets: [[SanzoColor]] {
        palette.colors.chunked(into: setSize)
    }

    private var currentSet: [SanzoColor] {
        guard !sets.isEmpty else { return [] }
        return sets[min(setIndex, sets.count - 1)]
    }

    private var exportText: String {
        currentSet.map { "\($0.name)  \($0.hex.uppercased())" }.joined(separator: "\n")
    }

    var body: some View {
        ZStack(alignment: .top) {

            VStack(spacing: 16) {
                header

                paletteVisual
                    .frame(height: 260)

                labelsRow(for: currentSet)

                if sets.count > 1 {
                    setPager
                }

                actionsRow

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 20)
        }
        .overlay(alignment: .top) {
            if copiedToast {
                Text("Copied")
                    .font(.caption)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.black.opacity(0.75))
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 999, style: .continuous))
                    .padding(.top, 70)
                    .transition(.opacity)
            }
        }
        .onChange(of: palette.id) { _, _ in
            setIndex = 0
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("Combination")
                    .font(.caption)
                    .textCase(.uppercase)
                    .tracking(1.2)
                    .foregroundStyle(.secondary)
            }

            HStack(alignment: .firstTextBaseline) {
                Text("#\(palette.id)")
                    .font(.system(.largeTitle, design: .serif))
                    .fontWeight(.semibold)

                Spacer()

                Text("\(palette.colors.count) colours")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Visual (Strip / Cross)

    private var paletteVisual: some View {
        Group {
            switch layout {
            case .strip:
                stripView(colors: currentSet)

            case .cross:
                if currentSet.count == 4 {
                    CrossPaletteView(colors: currentSet)
                        .frame(width: 420, height: 420)
                } else {
                    // Cross needs 4. Fall back to strip for the last partial set.
                    stripView(colors: currentSet)
                }
            }
        }
    }

    private func stripView(colors: [SanzoColor]) -> some View {
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

    // MARK: - Labels

    private func labelsRow(for colors: [SanzoColor]) -> some View {
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
                        .minimumScaleFactor(0.75)

                    Text(c.hex.uppercased())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Set pager

    private var setPager: some View {
        HStack(spacing: 10) {
            Button {
                setIndex = max(setIndex - 1, 0)
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(setIndex == 0)

            Text("Set \(setIndex + 1)/\(sets.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(minWidth: 110)

            Button {
                setIndex = min(setIndex + 1, sets.count - 1)
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(setIndex >= sets.count - 1)

            Spacer()

            Button {
                guard sets.count > 1 else { return }
                setIndex = Int.random(in: 0..<sets.count)
            } label: {
                Label("Random set", systemImage: "shuffle")
            }
            .labelStyle(.iconOnly)
        }
    }

    // MARK: - Actions

    private var actionsRow: some View {
        HStack(spacing: 12) {
            Button {
                PlatformPasteboard.copy(exportText)
                showCopiedToast()
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
                    .frame(maxWidth: .infinity)
            }
            #if os(macOS)
            .buttonStyle(.bordered)
            #else
            .buttonStyle(.borderedProminent)
            #endif

            ShareLink(item: exportText) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            if #available(iOS 16.0, macOS 13.0, *) {
                ShareImageButton(
                    title: "Share image",
                    systemImage: "photo",
                    paletteId: palette.id,
                    content: PaletteShareCard(
                        paletteId: palette.id,
                        layout: layout,
                        colors: currentSet
                    )
                )
            }
        }
        .font(.subheadline)
    }

    private func showCopiedToast() {
        withAnimation(.easeOut(duration: 0.15)) { copiedToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeIn(duration: 0.15)) { copiedToast = false }
        }
    }
}
