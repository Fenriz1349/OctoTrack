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
            ScrollView {
                ForEach(repositories) { repository in
                    RepoRow(repository: repository)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(repositories[index])
            }
        }
    }
}

#Preview {
    RepoListView(appViewModel: AppViewModel())
        .modelContainer(for: Repository.self, inMemory: true)
}
