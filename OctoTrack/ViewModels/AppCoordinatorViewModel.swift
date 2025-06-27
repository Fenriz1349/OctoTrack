//
//  AppCoordinatorViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/06/2025.
//

import Foundation

@MainActor
final class AppCoordinatorViewModel: ObservableObject {
    @Published var selectedTab: Tab = .repoList
    @Published var showAddModal = false

    let appViewModel: AppViewModel
    private let viewModelFactory: ViewModelFactory

    init(appViewModel: AppViewModel, viewModelFactory: ViewModelFactory) {
        self.appViewModel = appViewModel
        self.viewModelFactory = viewModelFactory
    }

    var isLogged: Bool {
        appViewModel.isLogged
    }

    var authenticationViewModel: AuthenticationViewModel {
        appViewModel.authenticationViewModel
    }

    func selectTab(_ tab: Tab) {
        if tab == .addRepo {
            showAddModal = true
        } else {
            selectedTab = tab
        }
    }

    func dismissAddModal() {
        showAddModal = false
    }

    func initialize() async {
        await appViewModel.initialize()
    }

    func makeRepoListViewModel() -> RepoListViewModel {
        return viewModelFactory.makeRepoListViewModel(viewModelFactory)
    }

    func makeAccountViewModel() -> AccountViewModel {
        return viewModelFactory.makeAccountViewModel(authenticationViewModel: authenticationViewModel,
                                                     viewModelFactory: viewModelFactory)
    }

    func makeAddRepoViewModel() -> AddRepoViewModel {
        return viewModelFactory.makeAddRepoViewModel()
    }
}
