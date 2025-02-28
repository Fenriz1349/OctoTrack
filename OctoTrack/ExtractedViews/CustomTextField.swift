//
//  CustomTextField.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import SwiftUI

enum TextFieldType {
    case email
    case password
    case decimal
    case alphaNumber
}

// Permet de gérer l'affichage de tous les Textfields de l'app suivant leur type
struct CustomTextField: View {
    let color: Color
    let placeholder: String
    var header: String? = nil
    @Binding var text: String
    let type: TextFieldType
    
    var body: some View {
        let (keyboardType, isSecure, disableAutocorrection) = configureTextField(type: type)
        
        VStack(alignment: .leading) {
            if let header = header {
                Text(header)
                    .font(.headline)
            }
            if isSecure {
                SecureField(placeholder, text: $text)
                    .stylize(color: color)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled(disableAutocorrection)
            } else {
                TextField(placeholder, text: $text)
                    .stylize(color: color)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled(disableAutocorrection)
                    .autocapitalization(type == .email ? .none : .sentences)
            }
        }
    }
}

extension CustomTextField {
    
    /// Configure the keyboardtype for CustomTextField
    /// - Parameter type: the texfieldType enum
    /// - Returns: the keyboard wanted, is isSecured, if is autocorrection disable
    func configureTextField(type: TextFieldType) -> (UIKeyboardType, Bool, Bool) {
        switch type {
        case .email: return (.emailAddress, false, true)
        case .password: return (.default, true, false)
        case .decimal: return (.decimalPad, false, false)
        case .alphaNumber: return (.namePhonePad, false, true)
        }
    }
}

extension SecureField {
    
    func stylize(color: Color) -> some View {
        self.modifier(TextFieldStyleModifier(color: color))
    }
}

extension TextField {
    
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
