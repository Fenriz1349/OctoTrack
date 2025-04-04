//
//  View+Ext.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/03/2025.
//

import SwiftUI

extension View {

    func stylize(color: Color) -> some View {
        self.modifier(TextFieldStyleModifier(color: color))
    }
}
