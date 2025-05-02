//
//  CustomButton.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import SwiftUI

struct CustomButtonLabel: View {
    let iconLeading: IconsName?
    let iconTrailing: IconsName?
    let message: String
    let color: Color
    let isSelected: Bool

    init(iconLeading: IconsName? = nil, iconTrailing: IconsName? = nil,
         message: String, color: Color, isSelected: Bool = true) {
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
            if let iconLeading = iconLeading { Image(systemName: iconLeading.rawValue) }
            Text(message)
            if let iconTrailing = iconTrailing {
                Spacer()
                Image(systemName: iconTrailing.rawValue)
                    .padding(.trailing, 20)
            }
        }
        .appButtonStyle(color: color, isSelected: isSelected)
    }
}

#Preview {
    CustomButtonLabel(iconLeading: .plus,
                      iconTrailing: .down,
                      message: "repoAdd", color: .accentColor)
}
