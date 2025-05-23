//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct RepoListView: View {
    @State var dataManager: UserDataManager
    #warning("ajouter un picker pour les priorités")
    #warning("ajouter un tri par date ou par priorité")
    var body: some View {
        NavigationStack {
            if let user = dataManager.activeUser {
                UserHeader(user: user)
            }
            NavigationLink(destination: AddRepositoryModal(dataManager: dataManager)) {
                CustomButtonLabel(iconLeading: .plus,
                                  message: "repoAdd",
                                  color: .black)
                .padding(.horizontal, 30)
            }
            List {
                ForEach(dataManager.activeUser?.repoList ?? []) { repository in
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
    }
}

#Preview {
    RepoListView(dataManager: UserDataManager.preview)
        .previewWithContainer()
}
