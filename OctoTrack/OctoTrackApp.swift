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
            fatalError("couldNotCreateMC".localized(error.localizedDescription))
        }
    }()

    init() {
           let dataManager = UserDataManager(modelContext: self.sharedModelContainer.mainContext)
           let viewModel = AppViewModel(dataManager: dataManager)

           self._dataManager = State(initialValue: dataManager)
           self._appViewModel = State(initialValue: viewModel)
       }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: appViewModel)
                .modelContainer(sharedModelContainer)
                .onAppear {
                    Task {
                        await appViewModel.initialize()
                    }
                }
        }
    }
}
