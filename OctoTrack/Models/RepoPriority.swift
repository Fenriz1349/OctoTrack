//
//  RepoPriority.swift
//  OctoTrack
//
//  Created by Julien Cotte on 18/04/2025.
//

import SwiftUI

enum RepoPriority: Int, Codable, CaseIterable {
    case all = 0
    case low = 1
    case medium = 2
    case high = 3

    var name: String {
        switch self {
        case.all: "all"
        case .low: "low"
        case .medium: "medium"
        case .high: "high"
        }
    }

    var color: Color {
        switch self {
        case.all: .customGray
        case .low: .customGreen
        case .medium: .customYellow
        case .high: .customRed
        }
    }

    var icon: IconsName {
        switch self {
        case .all: IconsName.folder
        case .low: IconsName.leaf
        case .medium: IconsName.bolt
        case .high: IconsName.flame
        }
    }
}
