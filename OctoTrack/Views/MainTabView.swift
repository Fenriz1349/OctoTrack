//
//  MainTabView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 23/05/2025.
//

import SwiftUI

struct MainTabView: View {
    @Binding var selectedTab: Tab
       @State private var showAddModal = false
       let viewModel: AppViewModel

       var body: some View {
           NavigationStack {
               Group {
                   switch selectedTab {
                   case .repoList:
                       RepoListView(dataManager: viewModel.dataManager)
                   case .account:
                       AccountView(appViewModel: viewModel)
                   case .addRepo:
                       EmptyView()
                   }
               }

               HStack {
                   TabBarButton( tab: .repoList,
                                 isSelected: selectedTab == .repoList,
                                 action: { selectedTab = .repoList }
                   )
                   
                   ZStack {
                       RoundedRectangle(cornerRadius: 50)
                           .fill(Color.blue.opacity(0.8))
                           .frame(width: 110, height: 56)
                           .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                       TabBarButton(tab: .addRepo,
                                    isSelected: false,
                                    action: {showAddModal = true },
                                    color: .white
                       )
                   }

                   TabBarButton(tab: .account,
                                isSelected: selectedTab == .account,
                                action: { selectedTab = .account }
                   )
               }
               .padding(.horizontal, 24)
               .padding(.vertical, 12)
               .padding(.bottom, -30)
               .background(
                Color(.systemBackground)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: -4)
                    .mask(
                        Rectangle()
                            .padding(.top, -20)
                    )
               )
           }
           .sheet(isPresented: $showAddModal) {
               AddRepositoryModal(dataManager: viewModel.dataManager)
           }
       }
   }

#Preview {
    MainTabView(selectedTab: .constant(.account), viewModel: PreviewContainer.previewAppViewModel)
}
