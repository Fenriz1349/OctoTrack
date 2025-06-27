//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI
import SwiftData

struct AppCoordinator: View {
    @StateObject var viewModel: AppCoordinatorViewModel
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        
        return Group {
            if appViewModel.isInitializing {
                VStack {
                    LoadingView()
                }
                .onAppear {
                    Task {
                        await viewModel.initialize()
                    }
                }
            } else if appViewModel.isLogged {
                VStack {
                    MainTabView(viewModel: viewModel)
                }
            } else {
                VStack {
                    AuthenticationView(viewModel: viewModel.authenticationViewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                removal: .move(edge: .top).combined(with: .opacity)))
                }
            }
        }
    }
}

#Preview {
    let dataManager = UserDataManager(modelContext: PreviewContainer.container.mainContext)
    let appViewModel = AppViewModel(dataManager: dataManager)
    let viewModelFactory = ViewModelFactory(dataManager: dataManager)
    let appCoordinatorViewModel = AppCoordinatorViewModel(
        appViewModel: appViewModel,
        viewModelFactory: viewModelFactory
    )
    
    AppCoordinator(viewModel: appCoordinatorViewModel, appViewModel: appViewModel)
        .modelContainer(PreviewContainer.container)
}
