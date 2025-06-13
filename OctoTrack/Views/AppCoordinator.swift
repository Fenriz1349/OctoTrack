//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI
import SwiftData

struct AppCoordinator: View {
    @State var viewModel: AppViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var  tab: Tab = .repoList

    var body: some View {
        Group {
            if viewModel.isInitializing {
                LoadingView()
                .task {
                    viewModel.dataManager.modelContext = modelContext
                    await viewModel.initialize()
                }
            } else if viewModel.isLogged {
                MainTabView(selectedTab: $tab, viewModel: viewModel)
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
    AppCoordinator(viewModel: viewModel)
        .previewWithContainer()
}
