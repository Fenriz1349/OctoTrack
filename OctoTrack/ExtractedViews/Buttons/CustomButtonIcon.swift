//
//  CustomButtonIcon.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/03/2025.
//

import SwiftUI

struct CustomButtonIcon: View {
    let icon: IconsName
    let color: Color
    var body: some View {
        Image(systemName: icon.rawValue)
        .fontWeight(.bold)
        .padding(7)
        .background(color)
        .foregroundColor(.buttonWhite)
        .cornerRadius(25)
        .shadow(color: .customGray, radius: 4, x: 2, y: 2)
    }
}

#Preview {
    CustomButtonIcon(icon: IconsName.refresh, color: .accentColor)
}
