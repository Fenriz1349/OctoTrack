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
    @Query private var items: [Item]
    var repositories: [Repository]? {
        appViewModel.userApp?.repoList
    }

    var body: some View {
        NavigationStack {
            if let user = appViewModel.userApp {
                UserHeader(user: user)
            }
            NavigationLink(destination: AddRepositoryModal(appViewModel: appViewModel)) {
                CustomButtonLabel(icon: nil, message: "repoAdd".localized, color: .black)
                    .padding(.horizontal, 30)
            }
            ScrollView {
                ForEach(repositories ?? []) { repository in
                    RepoRow(repository: repository)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    RepoListView(appViewModel: AppViewModel())
        .modelContainer(for: Item.self, inMemory: true)
}
