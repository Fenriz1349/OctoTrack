//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI
import SwiftData

struct RepoListView: View {
    @Environment(\.modelContext) private var modelContext
    @State var appViewModel: AppViewModel

    var repositories: [Repository] {
        appViewModel.userApp?.repoList ?? []
    }

    var body: some View {
        NavigationStack {
            if let user = appViewModel.userApp {
                UserHeader(user: user)
            }
            NavigationLink(destination: AddRepositoryModal(appViewModel: appViewModel)) {
                CustomButtonLabel(icon: IconsName.plus.rawValue,
                                  message: "repoAdd".localized,
                                  color: .black)
                .padding(.horizontal, 30)
            }
            List {
                ForEach(repositories) { repository in
                    RepoRow(repository: repository)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteRepository(repository)
                            } label: {
                                CustomButtonIcon(icon: "trash", color: .red)
                            }
                        }
                }
            }
        }
    }

    private func deleteRepository(_ repo: Repository) {
        withAnimation {
            appViewModel.userApp?.repoList.removeAll(where: { $0.id == repo.id})
            modelContext.delete(repo)
            try? modelContext.save()
        }
    }
}

#Preview {
    RepoListView(appViewModel: AppViewModel())
        .modelContainer(for: Repository.self, inMemory: true)
}
