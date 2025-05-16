//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel: AppViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var  tab: Tab = .repoList

    var body: some View {
        Group {
            if viewModel.isInitializing {
                VStack {
                    ProgressView()
                    Text("loading")
                        .padding()
                }

                .task {
                    viewModel.dataManager.modelContext = modelContext
                    await viewModel.initialize()
                }
            } else if viewModel.isLogged {
                TabView(selection: $tab) {
                    RepoListView(dataManager: viewModel.dataManager)
                    .tabItem { Tab.repoList.tabItem() }
                        .tag(Tab.repoList)
                    AccountView(appViewModel: viewModel)
                        .tabItem { Tab.account.tabItem() }
                        .tag(Tab.account)
                }
            } else {
                AuthenticationView(viewModel: viewModel.authenticationViewModel)
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .move(edge: .top).combined(with: .opacity)))
            }
        }
    }
}

#Preview {
    let viewModel = PreviewContainer.previewAppViewModel
    ContentView(viewModel: viewModel)
        .previewWithContainer()
}
