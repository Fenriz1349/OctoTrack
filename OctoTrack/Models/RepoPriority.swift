//
//  RepoPriority.swift
//  OctoTrack
//
//  Created by Julien Cotte on 18/04/2025.
//

import SwiftUI

enum RepoPriority: Int, Codable, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2

    var name: String {
        switch self {
        case .low: "low".localized
        case .medium: "medium".localized
        case .high: "high".localized
        }
    }

    var color: Color {
        switch self {
        case .low: .green
        case .medium: .yellow
        case .high: .red
        }
    }

    var icon: String {
        switch self {
        case .low: IconsName.leaf.rawValue
        case .medium: IconsName.bolt.rawValue
        case .high: IconsName.flame.rawValue
        }
    }
}
