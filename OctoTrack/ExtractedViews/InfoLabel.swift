//
//  InfoLabel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 07/03/2025.
//

import SwiftUI

struct InfoLabel: View {
    let message: String
    let isSuccess: Bool

    private var color: Color {
        isSuccess ? .green : .red
    }

    private var iconName: String {
        isSuccess ? IconsName.checkMark.rawValue : IconsName.xMark.rawValue
    }
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color)
            Text(isSuccess
                 ? "addedWithSuccess \(message)"
                 : "failCantAdd \(message)")
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
