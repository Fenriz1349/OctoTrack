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
           case .expired: "signAgain"
           case .authenticated: "continue"
           case .unauthenticated: "signIn"
           }
       }

    private var icon: IconsName {
        switch status {
        case .expired: .refresh
        case .authenticated: .continu
        case .unauthenticated: .login
        }
    }

    var body: some View {
        Button(action: {
            Task {
                try await onLogin()
            }
        },
        label: {
            CustomButtonLabel(iconLeading: icon, message: buttonLabel, color: .blue)
            }
        )
        if status == .expired || status == .authenticated {
            Button(action: {
                Task {
                    onSignOut
                }
            },
            label: {
                CustomButtonLabel(iconLeading: .signOut, message: "signOut", color: .red)
                }
            )
        }
    }
}

#Preview {
    AuthButtonsStack(status: .authenticated,
                     onLogin: {  },
                     onSignOut: { })
}
