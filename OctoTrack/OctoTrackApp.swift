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
    @State private var viewModel = AppViewModel()

    @State private var isInitializing: Bool = true
    var sharedModelContainer: ModelContainer = {
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

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .modelContainer(sharedModelContainer)
        }
    }
}
