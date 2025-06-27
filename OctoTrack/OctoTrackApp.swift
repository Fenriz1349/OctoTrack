//
//  OctoTrackApp.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI
import SwiftData

@main
struct OctoTrackApp: App {
    @State private var dataManager: UserDataManager
    @State private var appViewModel: AppViewModel
    @State private var viewModelFactory: ViewModelFactory
    @State private var appCoordinatorViewModel: AppCoordinatorViewModel

    private let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Owner.self,
            Repository.self,
            PullRequest.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError(String(format: "couldNotCreateMC", error.localizedDescription))
        }
    }()

    init() {
        let dataManager = UserDataManager(modelContext: self.sharedModelContainer.mainContext)
        let appViewModel = AppViewModel(dataManager: dataManager)

        let viewModelFactory = ViewModelFactory(dataManager: dataManager)
        let appCoordinatorViewModel = AppCoordinatorViewModel(
            appViewModel: appViewModel,
            viewModelFactory: viewModelFactory
        )

        self._dataManager = State(initialValue: dataManager)
        self._appViewModel = State(initialValue: appViewModel)
        self._viewModelFactory = State(initialValue: viewModelFactory)
        self._appCoordinatorViewModel = State(initialValue: appCoordinatorViewModel)
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinator(viewModel: appCoordinatorViewModel, appViewModel: appViewModel)
                .modelContainer(sharedModelContainer)
                .environmentObject(dataManager)
                .environmentObject(viewModelFactory)
        }
    }
}
