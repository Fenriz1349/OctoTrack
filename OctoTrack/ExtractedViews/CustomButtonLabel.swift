//
//  CustomButton.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import SwiftUI

struct CustomButtonLabel: View {
    var iconLeading: IconsName?
    var iconTrailing: IconsName?
    let message: String
    let color: Color
    var isSelected: Bool = true

    var body: some View {
        HStack {
            if iconTrailing != nil {
                Spacer()
            }
            if let iconLeading = iconLeading {
                Image(systemName: iconLeading.rawValue) }
            Text(LocalizedStringKey(message))
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
