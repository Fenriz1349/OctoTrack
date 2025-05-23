//
//  PRViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 24/04/2025.
//

import SwiftUI

@MainActor
@Observable final class RepoDetailsViewModel {

    enum Feedback: FeedbackHandler, Equatable {
        case none, noPR, updateFailed, deleteFailed

        var message: String? {
            switch self {
            case .none:  nil
            case .noPR: "noPR"
            case .updateFailed: "updateFailed"
            case .deleteFailed: "deleteFailed"
            }
        }

        var isError: Bool { true }
    }

    let repository: Repository
    var feedback: Feedback = .none
    var isLoading = false
    let dataManager: UserDataManager
    private let pullRequestGetter = PullRequestGetter()
    private let authenticator = GitHubAuthenticator()

    init(repository: Repository, dataManager: UserDataManager) {
        self.repository = repository
        self.dataManager = dataManager
    }

    func updateRepositoryPriority(_ priority: RepoPriority) {
        do {
            try dataManager.updateRepositoryPriority(repoId: repository.id, priority: priority)
        } catch {
            feedback = .updateFailed
        }
    }

    func getAllPullRequests(state: String = "all") async {
        isLoading = true
        do {
            let token = try await authenticator.retrieveToken()
            let request = try PullRequestEndpoint
                .request(owner: repository.owner.login, repoName: repository.name, token: token, state: state)
            var pullRequests = try await pullRequestGetter.allPullRequestsGetter(from: request)
            feedback = pullRequests.isEmpty ? .noPR : .none
            pullRequests.sort { $0.createdAt < $1.createdAt }
            try dataManager.storePullRequests(pullRequests, repositoryiD: repository.id)
            isLoading = false
        } catch {
            feedback = .updateFailed
            isLoading = false
        }
    }

    func deletePullRequest(_ pullRequest: PullRequest) {
        withAnimation {
            do {
                try dataManager.deletePullRequest(repoId: repository.id, prId: pullRequest.id)
            } catch {
                feedback = .deleteFailed
            }
        }
    }
}
