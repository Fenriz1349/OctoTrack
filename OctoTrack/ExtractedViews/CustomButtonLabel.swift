//
//  CustomButton.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import SwiftUI

struct CustomButtonLabel: View {
    let icon: String?
    let message: String
    let color: Color
    var body: some View {
        HStack {
            if let icon = icon { Image(systemName: icon) }
            Text(message)
        }
        .fontWeight(.bold)
        .frame(maxWidth: .infinity)
        .padding()
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.4), radius: 6, x: -4, y: -4)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 4, y: 4)
    }
}

#Preview {
    CustomButtonLabel(icon: nil, message: "repoAdd".localized, color: .accentColor)
}
