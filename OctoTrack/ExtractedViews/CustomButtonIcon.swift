//
//  CustomButtonIcon.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/03/2025.
//

import SwiftUI

struct CustomButtonIcon: View {
    let icon: String
    let color: Color
    var body: some View {
        Image(systemName: icon)
        .fontWeight(.bold)
        .padding(7)
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.4), radius: 6, x: -4, y: -4)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 4, y: 4)
    }
}

#Preview {
    CustomButtonIcon(icon: IconsName.refresh.rawValue, color: .accentColor)
}
