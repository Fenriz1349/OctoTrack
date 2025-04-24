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
            if appViewModel.isInitializing {
                VStack {
                    ProgressView()
                    Text("loading".localized).padding()
                }

                .task {
                    viewModel.dataManager.modelContext = modelContext
                    await viewModel.initialize()
                }
            } else if viewModel.isLogged {
                TabView(selection: $tab ){
                    ForEach(Tab.allCases) { tabItem in
                        switch tabItem {
                        case .repoList:
                            RepoListView(appViewModel: viewModel)
                                .tabItem(for: tabItem)
                        case .account:
                            AccountView(appViewModel: viewModel)
                                .tabItem(for: tabItem)
                        }
                    }
                }
            } else {
                AuthenticationView(viewModel: appViewModel.authenticationViewModel)
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
