//
//  AppButtonStyle.swift
//  OctoTrack
//
//  Created by Julien Cotte on 24/04/2025.
//

import SwiftUI

struct AppButtonStyle: ViewModifier {
    var color: Color
    var isSelected: Bool = true

    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(isSelected ? color : Color.clear)
            .foregroundColor(isSelected ? .buttonWhite : color)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: isSelected ? 0 : 2)
            )
            .shadow(
                color: isSelected ? .primary.opacity(0.3) : .clear,
                radius: 4,
                x: 0,
                y: isSelected ? 0 : 2
            )
            .scaleEffect(isSelected ? 1.0 : 0.95)
    }
}
