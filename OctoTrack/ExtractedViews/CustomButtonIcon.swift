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
        .cornerRadius(25)
        .shadow(color: .gray/*.opacity(0.2)*/, radius: 4, x: 2, y: 2)
    }
}

#Preview {
    CustomButtonIcon(icon: IconsName.refresh.rawValue, color: .accentColor)
}
