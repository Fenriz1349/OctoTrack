//
//  CustomTextField.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import SwiftUI

// Permet de gérer l'affichage de tous les Textfields de l'app suivant leur type
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

extension View {

    func stylize(color: Color) -> some View {
        self.modifier(TextFieldStyleModifier(color: color))
    }
}

struct TextFieldStyleModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(color)
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
