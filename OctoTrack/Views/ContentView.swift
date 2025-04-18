//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var appViewModel: AppViewModel

    var body: some View {
        Group {
            if appViewModel.isInitializing {
                VStack {
                    ProgressView()
                    Text("loading".localized).padding()
                }
            } else if appViewModel.isLogged {
                TabView {
                    RepoListView(viewModel: RepoListViewModel(dataManager: appViewModel.dataManager))
                        .tabItem {
                            Image(systemName: "folder.fill")
                            Text("repoList".localized)
                        }
                    AccountView(appViewModel: appViewModel)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("account".localized)
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

//#Preview {
//    ContentView(appViewModel: AppViewModel(dataManager: UserDataManager(modelContext: ModelContext())))
//}
