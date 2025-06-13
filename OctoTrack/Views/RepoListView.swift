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

    @Query private var allRepositories: [Repository]
      
      var selectedRepositories: [Repository] {
          let userRepositories = allRepositories.filter { repo in
              dataManager.activeUser?.repoList.contains(where: { $0.id == repo.id }) ?? false
          }
          let sortedRepos = userRepositories.sorted { $0.mostRecentUpdate > $1.mostRecentUpdate }
          
          return selectedPriority == .all ? sortedRepos
              : sortedRepos.filter { $0.priority == selectedPriority }
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
