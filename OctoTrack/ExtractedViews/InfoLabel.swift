//
//  InfoLabel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 07/03/2025.
//

import SwiftUI

struct InfoLabel: View {
    let message: String
    let isSuccess: Bool

    var body: some View {
        HStack {
            Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isSuccess ? .green : .red)

            Text(isSuccess
                 ? "\(message) ajouté avec succès!"
                 : "Échec : impossible d'ajouter \(message)")
                .fontWeight(.medium)
        }
        .padding()
        .background(isSuccess ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    InfoLabel(message: "ceci est un test", isSuccess: false)
}
