//
//  PRViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 24/04/2025.
//

import SwiftUI

@MainActor
@Observable final class PullRequestViewModel {
    let repository: Repository
    // To handle feedback on the view
    var feedbackMessage: String?
    var isLoading = false
    let dataManager: UserDataManager
    private let pullRequestGetter = PullRequestGetter()
    private let authenticator = GitHubAuthenticator()

    init(repository: Repository, dataManager: UserDataManager) {
        self.repository = repository
        self.dataManager = dataManager
    }

    func updateRepositoryPriority(_ priority: RepoPriority) {
        dataManager.updateRepositoryPriority(repoId: repository.id, priority: priority)
    }

    private func getAllPullRequests(state: String = "all") async -> Result<[PullRequest], Error> {
        isLoading = true
        do {
            let token = try await authenticator.retrieveToken()
            let request = try PullRequestEndpoint
                .request(owner: repository.owner.login, repoName: repository.name, token: token, state: state)
            let pullRequests = try await pullRequestGetter.allPullRequestsGetter(from: request)
            isLoading = false
            checkIfEmptyPullRequest()
            return(.success(pullRequests))
        } catch {
            feedbackMessage = "\(repository.owner.login)/\(repository.name)"
            isLoading = false
            return .failure(error)
        }
    }

    func updatePullRequests() async {
        let getPullRequests = await getAllPullRequests()
        switch getPullRequests {
        case .success(var pullRequests):
            pullRequests.sort { $0.createdAt < $1.createdAt }
            dataManager.storePullRequests(pullRequests, repositoryiD: repository.id)
        case .failure:
            feedbackMessage = "updateFailed"
        }
    }

    func deletePullRequest(_ pullRequest: PullRequest) {
        withAnimation {
            dataManager.deletePullRequest(repoId: repository.id, prId: pullRequest.id)
        }
    }

    private func checkIfEmptyPullRequest() {
        feedbackMessage = dataManager.allUsers.isEmpty ? "noPR" : nil
    }
}
