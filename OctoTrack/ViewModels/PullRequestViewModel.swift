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
    var showFeedback = false
    var feedbackMessage = ""
    var isSuccess = false
    var isLoading = false

    let dataManager: UserDataManager
    private let pullRequestGetter = PullRequestGetter()
    private let authenticator = GitHubAuthenticator()

    init(repository: Repository, dataManager: UserDataManager) {
            self.repository = repository
            self.dataManager = dataManager
        }

    private func getAllPullRequests(state: String = "all") async -> Result<[PullRequest], Error> {
        isLoading = true
        do {
            let token = try await authenticator.retrieveToken()
            let request = try PullRequestEndpoint
                .request(owner: repository.owner.login, repoName: repository.name, token: token, state: state)
            let pullRequests = try await pullRequestGetter.allPullRequestsGetter(from: request)
            isLoading = false
            return(.success(pullRequests))
        } catch {
            isSuccess = false
            feedbackMessage = "\(repository.owner.login)/\(repository.name)"
            showFeedback = true
            isLoading = false
            return .failure(error)
        }
    }

    func updatePullRequests() async {
        let getPullRequests = await getAllPullRequests()
        switch getPullRequests {
        case .success(let pullRequests):
            dataManager.storePullRequest(pullRequests, repositoryiD: repository.id)
        case .failure:
            break
        }
    }

    func resetFeedback() {
        feedbackMessage = ""
        showFeedback = false
    }

    func deletePullRequest(_ pullRequest: PullRequest) {
        withAnimation {
            dataManager.deletePullRequest(repoId: repository.id, prId: pullRequest.id)
        }
    }
}
