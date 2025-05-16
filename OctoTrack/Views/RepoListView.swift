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

    var body: some View {
        NavigationStack {
            UserHeader(user: dataManager.activeUser)
            NavigationLink(destination: AddRepositoryModal(dataManager: dataManager)) {
                CustomButtonLabel(iconLeading: .plus,
                                  message: "repoAdd",
                                  color: .black)
                .padding(.horizontal, 30)
            }
            List {
                ForEach(dataManager.activeUser.repoList) { repository in
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Repository.self, configurations: config)
        let mockDataManager = UserDataManager(modelContext: ModelContext(container))
        return RepoListView(dataManager: mockDataManager)
            .previewWithContainer()
    } catch {
        return Text("Erreur: \(error.localizedDescription)")
    }
}
