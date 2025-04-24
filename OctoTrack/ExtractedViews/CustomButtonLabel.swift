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
    let isSelected: Bool

    init(icon: String?, message: String, color: Color, isSelected: Bool = true) {
            self.icon = icon
            self.message = message
            self.color = color
            self.isSelected = isSelected
        }

    var body: some View {
        HStack {
            if let icon = icon { Image(systemName: icon) }
            Text(message)
        }
        .appButtonStyle(color: color, isSelected: isSelected)
    }
}

#Preview {
    CustomButtonLabel(icon: nil, message: "repoAdd".localized, color: .accentColor)
}
