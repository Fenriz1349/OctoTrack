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
            .background(color.opacity(isSelected ? 1.0 : 0.8))
            .foregroundColor(isSelected ? .white : .gray)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            )
            .shadow(
                color: isSelected ? .black.opacity(0.3) : .clear,
                radius: 4,
                x: 0,
                y: isSelected ? 0 : 2
            )
            .scaleEffect(isSelected ? 1.0 : 0.95)
    }
}
