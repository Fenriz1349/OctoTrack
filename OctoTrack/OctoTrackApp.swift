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
    @State var viewModel = AppViewModel()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self
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
            Group {
                if viewModel.isLogged {
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
        }
        .modelContainer(sharedModelContainer)
    }
}
