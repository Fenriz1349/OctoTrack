//
//  RepoListViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/06/2025.
//

import SwiftUI

@MainActor
final class RepoListViewModel: ObservableObject {
    enum Feedback: FeedbackHandler, Equatable {
        case none
        case deleteFail(repoName: String, error: String)

        var message: String? {
            switch self {
            case .none: return nil
            case .deleteFail(let repoName, let error):
                return String(localized: "addFail \(repoName): \(error)")
            }
        }

        var isError: Bool {
            switch self {
            case .none: return false
            case .deleteFail: return true
            }
        }
    }

    let dataManager: UserDataManager
    let viewModelFactory: ViewModelFactory
    @Published var selectedPriority: RepoPriority = .all
    @Published var feedback: Feedback = .none

    init(dataManager: UserDataManager, viewModelFactory: ViewModelFactory) {
            self.dataManager = dataManager
            self.viewModelFactory = viewModelFactory
        }

    var selectedRepositories: [Repository] {
        return dataManager.getRepositoryList(with: selectedPriority)
            .sorted { $0.mostRecentUpdate > $1.mostRecentUpdate }
    }

    var repositoryCount: Int {
        return selectedRepositories.count
    }

    func deleteRepository(_ repository: Repository) {
        do {
            try dataManager.deleteRepository(repository)
        } catch {
            feedback = .deleteFail(repoName: repository.name, error: error.localizedDescription)
        }
    }
}
