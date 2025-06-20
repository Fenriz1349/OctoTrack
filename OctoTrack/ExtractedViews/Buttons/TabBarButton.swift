//
//  TabBarButton.swift
//  OctoTrack
//
//  Created by Julien Cotte on 23/05/2025.
//

import SwiftUI

struct TabBarButton: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void
    var color: Color?

    var displayedColor: Color {
        if let color = color { return color }
        return isSelected ? .accentColor : .customGray
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.tabIcon.rawValue)
                    .font(.title3)
                    .foregroundColor(displayedColor)

                Text(tab.tabLabel)
                    .font(.caption2)
                    .foregroundColor(displayedColor)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    TabBarButton(tab: .addRepo, isSelected: true, action: { })
}
