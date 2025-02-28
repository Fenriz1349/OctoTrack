//
//  AccountView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/02/2025.
//

import SwiftUI

struct AccountView: View {
    @State private var appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self._appViewModel = State(initialValue: appViewModel)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Profile header
            if let user = appViewModel.userApp {
                UserHeader(user: user)
            } else {
                Text("User data not available")
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 16) {
                Button {
                    Task {
                        do {
                            if let user = try? await appViewModel.authenticationViewModel.getUser() {
                                appViewModel.loginUser(user: user)
                            }
                        }
                    }
                } label: {
                    CustomButtonLabel(
                        icon: "arrow.clockwise",
                        message: "Refresh User Data",
                        color: Color.blue
                    )
                }
                
                Button {
                    appViewModel.userApp?.repoList = []
                } label: {
                    CustomButtonLabel(
                        icon: "trash",
                        message: "Reset Repository List",
                        color: Color.orange
                    )
                }
                
                Button {
                    appViewModel.authenticationViewModel.signOut()
                } label: {
                    CustomButtonLabel(
                        icon: "rectangle.portrait.and.arrow.right",
                        message: "Sign Out",
                        color: Color.red
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .padding()
        .navigationTitle("Account")
    }
}

#Preview {
    NavigationView {
        AccountView(appViewModel: AppViewModel())
    }
}
