//
//  TextFiledType.swift
//  OctoTrack
//
//  Created by Julien Cotte on 07/03/2025.
//

import SwiftUI

struct TextFieldConfig {
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let disableAutocorrection: Bool
    let autocapitalization: TextInputAutocapitalization
}

enum TextFieldType {
    case email
    case password
    case decimal
    case alphaNumber

    var config: TextFieldConfig {
        switch self {
        case .email:
            return TextFieldConfig(
                keyboardType: .emailAddress,
                isSecure: false,
                disableAutocorrection: true,
                autocapitalization: .never
            )
        case .password:
            return TextFieldConfig(
                keyboardType: .asciiCapable,
                isSecure: true,
                disableAutocorrection: true,
                autocapitalization: .never
            )
        case .decimal:
            return TextFieldConfig(
                keyboardType: .decimalPad,
                isSecure: false,
                disableAutocorrection: false,
                autocapitalization: .sentences
            )
        case .alphaNumber:
            return TextFieldConfig(
                keyboardType: .asciiCapable,
                isSecure: false,
                disableAutocorrection: true,
                autocapitalization: .words
            )
        }
    }
}
