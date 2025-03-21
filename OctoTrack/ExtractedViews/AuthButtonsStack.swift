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
           case .expired: "signAgain".localized
           case .authenticated: "continue".localized
           case .unauthenticated: "signIn".localized
           }
       }

    private var icon: String {
        switch status {
        case .expired: IconsName.refresh.rawValue
        case .authenticated: IconsName.continu.rawValue
        case .unauthenticated: IconsName.login.rawValue
        }
    }

    var body: some View {
        Button(action: {
            Task {
                try await onLogin()
            }
        },
        label: {
            CustomButtonLabel(icon: icon, message: buttonLabel, color: .black)
            }
        )
        if status == .expired || status == .authenticated {
            Button(action: {
                Task {
                    onSignOut
                }
            },
            label: {
                CustomButtonLabel(icon: IconsName.signOut.rawValue, message: "signOut".localized, color: .red)
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
