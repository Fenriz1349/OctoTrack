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
    var color: Color = .accentColor
    var isSelected: Bool = true
    var fontSize: CGFloat = 16

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
        .font(.system(size: fontSize))
        .appButtonStyle(color: color, isSelected: isSelected)
    }
}

#Preview {
    CustomButtonLabel(iconLeading: .plus,
                      iconTrailing: .down,
                      message: "repoAdd")
}
