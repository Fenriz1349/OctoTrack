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
            .padding()
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.customGray.opacity(0.3), lineWidth: 2)
            )
            .cornerRadius(8)
            .shadow(color: .primary.opacity(0.3), radius: 4, x: 1, y: 2)
            .keyboardType(config.keyboardType)
            .autocorrectionDisabled(config.disableAutocorrection)
            .textInputAutocapitalization(config.autocapitalization)
        }
    }
}
