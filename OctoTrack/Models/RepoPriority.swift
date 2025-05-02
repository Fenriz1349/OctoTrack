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
        case .low: "low"
        case .medium: "medium"
        case .high: "high"
        }
    }

    var color: Color {
        switch self {
        case .low: .green
        case .medium: .yellow
        case .high: .red
        }
    }

    var icon: IconsName {
        switch self {
        case .low: IconsName.leaf
        case .medium: IconsName.bolt
        case .high: IconsName.flame
        }
    }
}
