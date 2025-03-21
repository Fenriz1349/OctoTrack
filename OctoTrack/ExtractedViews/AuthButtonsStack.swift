//
//  AuthButtonsStack.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/03/2025.
//

import SwiftUI

struct AuthButtonsStack: View {
    let status: AuthenticationState
    let onLogin: () async throws -> Void
    let onSignOut: () -> Void
    private var buttonLabel: String {
        switch status {
           case .expired:
               return "signAgain".localized
           case .authenticated:
               return "continue".localized
           case .unauthenticated:
               return "signIn".localized
           }
       }
    var body: some View {
        Button(action: {
            Task {
                try await onLogin()
            }
        },
        label: {
            CustomButtonLabel(icon: nil, message: buttonLabel, color: .black)
            }
        )
        if status == .expired || status == .authenticated {
            Button(action: {
                Task {
                    onSignOut
                }
            },
            label: {
                CustomButtonLabel(icon: nil, message:"signOut".localized , color: .red)
                }
            )
        }
    }
}

#Preview {
    AuthButtonsStack(status: .unauthenticated,
                     onLogin: {  },
                     onSignOut: { })
}
