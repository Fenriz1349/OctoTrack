//
//  AddRepoViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

@MainActor
@Observable final class AddRepoViewModel {

    enum Feedback: FeedbackHandler, Equatable {
        case none
        case addSuccess(owner: String, repoName: String)
        case addFailed(owner: String, repoName: String, error: String)

        var message: String? {
            switch self {
            case .none:
                return nil
            case .addSuccess(let owner, let repoName):
                return "Successfully added \(owner)/\(repoName)"
            case .addFailed(let owner, let repoName, let error):
                return "Failed to add \(owner)/\(repoName): \(error)"
            }
        }

        var isError: Bool {
            switch self {
            case .none, .addSuccess:
                return false
            case .addFailed:
                return true
            }
        }
    }

    var owner: String
#warning("supprimer la valeur par defaut dans la version finale")
    var repoName: String = "DA-iOS_P5"
    var priority: RepoPriority = .low
    let dataManager: UserDataManager
    private let repoGetter: RepoGetter = RepoGetter()
    private let authenticator = GitHubAuthenticator()

    var feedback: Feedback = .none
    var isLoading = false

    var isFormValid: Bool {
        !owner.isEmpty && !repoName.isEmpty
    }

    init(dataManager: UserDataManager) {
        self.dataManager = dataManager
        self.owner = dataManager.activeUser?.login ?? ""
    }
    #warning("ajouter un cas lorsque le repo est deja dans le user")
    #warning("ajouter un cas lorsque le repo existe deja et le recuperer")
    func getRepo() async {
        isLoading = true
        do {
            let token = try await authenticator.retrieveToken()
            let request = try RepoEndpoint.request(owner: owner, repoName: repoName, token: token)
            let repo = try await repoGetter.repoGetter(from: request)

            repo.priority = priority
            try dataManager.storeNewRepo(repo)
            feedback = .addSuccess(owner: owner, repoName: repoName)
            isLoading = false
        } catch {
            feedback = .addFailed(owner: owner, repoName: repoName, error: error.localizedDescription)
            isLoading = false
        }
    }
}
