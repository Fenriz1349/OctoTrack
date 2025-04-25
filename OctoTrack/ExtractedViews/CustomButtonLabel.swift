//
//  CustomButton.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import SwiftUI

struct CustomButtonLabel: View {
    let iconLeading: String?
    let iconTrailing: String?
    let message: String
    let color: Color
    let isSelected: Bool

    init(iconLeading: String? = nil, iconTrailing: String? = nil, message: String, color: Color, isSelected: Bool = true) {
        self.iconLeading = iconLeading
        self.iconTrailing  = iconTrailing
        self.message = message
        self.color = color
        self.isSelected = isSelected
    }

    var body: some View {
        HStack {
            if iconTrailing != nil {
                Spacer()
            }
            if let iconLeading = iconLeading { Image(systemName: iconLeading) }
            Text(message)
            if let iconTrailing = iconTrailing {
                Spacer()
                Image(systemName: iconTrailing)
                    .padding(.trailing, 20)
            }
        }
        .appButtonStyle(color: color, isSelected: isSelected)
    }
}

#Preview {
    CustomButtonLabel(iconLeading: IconsName.plus.rawValue,
                      iconTrailing: IconsName.down.rawValue,
                      message: "repoAdd".localized, color: .accentColor)
}
