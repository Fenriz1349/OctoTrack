//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI
import SwiftData

struct RepoListView: View {
    @State var viewModel: RepoListViewModel

    var body: some View {
        NavigationStack {
            if let user = viewModel.activeUser {
                UserHeader(user: user, repositories: viewModel.repositories)
            }
            NavigationLink(destination: AddRepositoryModal(dataManager: viewModel.dataManager)) {
                CustomButtonLabel(icon: IconsName.plus.rawValue,
                                  message: "repoAdd".localized,
                                  color: .black)
                .padding(.horizontal, 30)
            }
            List {
                ForEach(viewModel.repositories) { repository in
                    RepoRow(repository: repository)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteRepository(repository)
                            } label: {
                                CustomButtonIcon(icon: "trash", color: .red)
                            }
                        }
                }
            }
        }
    }
}

//#Preview {
//    let viewModel = PreviewContainer.previewAppViewModel
//    RepoListView(appViewModel: viewModel)
//        .previewWithContainer()
//}
