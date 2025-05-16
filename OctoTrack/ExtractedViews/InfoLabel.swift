//
//  InfoLabel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 07/03/2025.
//

import SwiftUI

struct InfoLabel: View {
    let message: String
    var showIcon: Bool = true
    var isSuccess: Bool = false

    private var color: Color {
        isSuccess ? .green : .red
    }

    private var iconName: String {
        isSuccess ? IconsName.checkMark.rawValue : IconsName.xMark.rawValue
    }
    
    var body: some View {
        HStack {
            if showIcon {
                Image(systemName: iconName)
                    .foregroundColor(color)
            }
            Text(message)
            .fontWeight(.medium)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    InfoLabel(message: "this is a test", isSuccess: false)
}
