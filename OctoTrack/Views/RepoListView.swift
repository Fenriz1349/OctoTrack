//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI
import SwiftData

struct RepoListView: View {
    @State var dataManager: UserDataManager
    @State var selectedPriority: RepoPriority = .all

//    @Query private var allRepositories: [Repository]
      
    var selectedRepositories: [Repository] {
            // ✅ Directement via dataManager
            guard let activeUser = dataManager.activeUser else { return [] }
            let userRepositories = activeUser.repoList.sorted { $0.mostRecentUpdate > $1.mostRecentUpdate }
            return selectedPriority == .all ? userRepositories
                : userRepositories.filter { $0.priority == selectedPriority }
        }

    var body: some View {
        VStack {
            UserHeader(isCompact: true)
            PriorityButtonsStack(selectedPriority: $selectedPriority, showAll: true)
            List {
                ForEach(selectedRepositories) { repository in
                    NavigationLink(destination: RepoDetailView(repository: repository,
                                                               dataManager: dataManager)) {
                        RepoRow(repository: repository)
                    }
                    .listRowInsets(EdgeInsets())
                    .swipeActions(edge: .trailing) {
                       Button(role: .destructive) {
                           try? dataManager.deleteRepository(repository)
                       } label: {
                           CustomButtonIcon(icon: .trash, color: .red)
                       }
                   }
                }
            }
            .listStyle(.plain)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    RepoListView(dataManager: PreviewContainer.previewAppViewModel.dataManager)
        .previewWithContainer()
}
