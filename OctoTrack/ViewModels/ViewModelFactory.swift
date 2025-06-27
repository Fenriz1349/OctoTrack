//
//  ViewModelFactory.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/06/2025.
//

import Foundation

@MainActor
final class ViewModelFactory: ObservableObject {
    private let dataManager: UserDataManager
    
    init(dataManager: UserDataManager) {
        self.dataManager = dataManager
    }
    
    func makeRepoListViewModel(_ viewModelFactory: ViewModelFactory) -> RepoListViewModel {
        return RepoListViewModel(dataManager: dataManager, viewModelFactory: viewModelFactory)
    }
    
    func makeAddRepoViewModel() -> AddRepoViewModel {
        return AddRepoViewModel(dataManager: dataManager)
    }
    
    func makeAccountViewModel(authenticationViewModel: AuthenticationViewModel, viewModelFactory: ViewModelFactory) -> AccountViewModel {
        return AccountViewModel(dataManager: dataManager, authenticationViewModel: authenticationViewModel, viewModelFactory: viewModelFactory)
    }

    func makeRepoDetailsViewModel(repository: Repository) -> RepoDetailsViewModel {
        return RepoDetailsViewModel(repository: repository, dataManager: dataManager)
    }
}
