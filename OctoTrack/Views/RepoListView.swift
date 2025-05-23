//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct RepoListView: View {
    @State var dataManager: UserDataManager
    @State var selectedPriority: RepoPriority = .all
    var repositoryList: [Repository] {
        return selectedPriority == .all
        ? dataManager.activeUser?.repoList ?? []
        : dataManager.activeUser?.repoList.filter{ $0.priority == selectedPriority} ?? []
    }
    #warning("ajouter un tri par date ou par priorité")
    var body: some View {
        NavigationStack {
            if let user = dataManager.activeUser {
                UserHeader(user: user, isCompact: true)
            }
            NavigationLink(destination: AddRepositoryModal(dataManager: dataManager)) {
                CustomButtonLabel(iconLeading: .plus,
                                  message: "repoAdd",
                                  color: .black)
                .padding(.horizontal, 30)
            }
            PriorityButtonsStack(selectedPriority: $selectedPriority, showAll: true)
            List {
                ForEach(repositoryList) { repository in
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
            .refreshable {
                withAnimation {
                    dataManager.orderRepositories()
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    RepoListView(dataManager: UserDataManager.preview)
        .previewWithContainer()
}
