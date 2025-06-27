//
//  MainTabView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 23/05/2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel: AppCoordinatorViewModel

       var body: some View {
           NavigationStack {
               Group {
                   switch viewModel.selectedTab {
                   case .repoList:
                       RepoListView(viewModel: viewModel.makeRepoListViewModel())
                   case .account:
                       AccountView(viewModel: viewModel.makeAccountViewModel())
                   case .addRepo:
                       EmptyView()
                   }
               }

               HStack {
                   TabBarButton( tab: .repoList,
                                 isSelected: viewModel.selectedTab == .repoList,
                                 action: { viewModel.selectedTab = .repoList }
                   )

                   ZStack {
                       RoundedRectangle(cornerRadius: 50)
                           .fill(Color.accentColor.opacity(0.8))
                           .frame(width: 110, height: 56)
                           .shadow(color: .accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                       TabBarButton(tab: .addRepo,
                                    isSelected: false,
                                    action: {viewModel.showAddModal = true },
                                    color: .buttonWhite
                       )
                   }

                   TabBarButton(tab: .account,
                                isSelected: viewModel.selectedTab == .account,
                                action: { viewModel.selectedTab = .account }
                   )
               }
               .padding(.horizontal, 24)
               .padding(.vertical, 12)
               .padding(.bottom, -30)
               .background(
                Color(.systemBackground)
                    .shadow(color: .primary.opacity(0.2), radius: 8, x: 0, y: -4)
                    .mask(
                        Rectangle()
                            .padding(.top, -20)
                    )
               )
           }
           .sheet(isPresented: $viewModel.showAddModal) {
               AddRepositoryModal(viewModel: viewModel.makeAddRepoViewModel())
                   .onDisappear {
                       viewModel.dismissAddModal()
                   }
           }
       }
   }

#Preview {
    let appCoordinatorViewModel = AppCoordinatorViewModel(
        appViewModel: PreviewContainer.previewAppViewModel,
        viewModelFactory: PreviewContainer.previewViewModelFactory
    )

    MainTabView(viewModel: appCoordinatorViewModel)
        .modelContainer(PreviewContainer.container)
}
