//
//  Array+Chunked.swift
//  ColorCombinations
//
//  Created by Bashir Towdiee on 24/1/2026.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [self] }
        var result: [[Element]] = []
        var idx = 0
        while idx < count {
            let end = Swift.min(idx + size, count)
            result.append(Array(self[idx..<end]))
            idx += size
        }
        return result
    }
}
