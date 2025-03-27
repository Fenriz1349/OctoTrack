//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: AppViewModel
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Group {
            if viewModel.isInitializing {
                VStack {
                    ProgressView()
                    Text("loading".localized).padding()
                }
                .task {
                    viewModel.dataManager.modelContext = modelContext
                    await viewModel.initialize()
                }
            } else if viewModel.isLogged {
                TabView {
                    RepoListView(appViewModel: viewModel)
                        .tabItem {
                            Image(systemName: "folder.fill")
                            Text("repoList".localized)
                        }
                    AccountView(appViewModel: viewModel)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("account".localized)
                        }
                }
            } else {
                AuthenticationView(viewModel: viewModel.authenticationViewModel)
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .move(edge: .top).combined(with: .opacity)))
            }
        }
        .onAppear {
            viewModel.dataManager.setModelContext(modelContext)
        }
    }
}

#Preview {
    ContentView(viewModel: AppViewModel())
}
