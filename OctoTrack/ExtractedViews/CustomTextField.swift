//
//  CustomTextField.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import SwiftUI

// Manage display of textfields depending on their type
struct CustomTextField: View {
    var header: String?
    let color: Color
    let placeholder: String
    @Binding var text: String
    let type: TextFieldType

    var body: some View {
        let config = type.config

        VStack(alignment: .leading, spacing: 5) {
            if let header = header {
                Text(header)
                    .font(.headline)
            }
            Group {
                if config.isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .stylize(color: color)
            .keyboardType(config.keyboardType)
            .autocorrectionDisabled(config.disableAutocorrection)
            .textInputAutocapitalization(config.autocapitalization)
        }
    }
}

struct TextFieldStyleModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(color)
            .cornerRadius(8)
            .shadow(color: .primary.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
