//
//  PRViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 24/04/2025.
//

import SwiftUI

@MainActor
final class RepoDetailsViewModel: ObservableObject {

    enum Feedback: FeedbackHandler, Equatable {
        case none,
             noPR,
             updateFailed(error: String),
             deleteFailed(error: String)

        var message: String? {
            switch self {
            case .none:  nil
            case .noPR: String(localized: "noPR")
            case .updateFailed(let error): String(localized: "updateFailed \(error)")
            case .deleteFailed(let error): String(localized: "deleteFailed \(error)")
            }
        }

        var isError: Bool { true }
    }

    let repository: Repository
    @Published var feedback: Feedback = .none
    @Published var isLoading = false
    @Published var showPriorityPicker = false
    let dataManager: UserDataManager
    private let pullRequestGetter = PullRequestGetter()
    private let authenticator = GitHubAuthenticator()

    var sortedPullRequests: [PullRequest] {
        repository.pullRequests.sorted { $0.createdAt > $1.createdAt }
    }

    var shouldShowFeedback: Bool {
        feedback != .none
    }

    init(repository: Repository, dataManager: UserDataManager) {
        self.repository = repository
        self.dataManager = dataManager
    }

    func onViewAppear() {
           Task {
               await getAllPullRequests()
           }
       }

    func updateRepositoryPriority(_ priority: RepoPriority) {
        do {
            try dataManager.updateRepositoryPriority(repoId: repository.id, priority: priority)
        } catch {
            feedback = .updateFailed(error: error.localizedDescription)
        }
    }

    func getAllPullRequests(state: String = "all") async {
        isLoading = true
        do {
            let token = try await authenticator.retrieveToken()
            let request = try PullRequestEndpoint
                .request(owner: repository.owner.login, repoName: repository.name, token: token, state: state)
            let pullRequests = try await pullRequestGetter.allPullRequestsGetter(from: request)
            feedback = pullRequests.isEmpty ? .noPR : .none
            try dataManager.storePullRequests(pullRequests, repositoryiD: repository.id)
            isLoading = false
        } catch {
            feedback = .updateFailed(error: error.localizedDescription)
            isLoading = false
        }
    }

    func deletePullRequest(_ pullRequest: PullRequest) {
        withAnimation {
            do {
                try dataManager.deletePullRequest(repoId: repository.id, prId: pullRequest.id)
            } catch {
                feedback = .deleteFailed(error: error.localizedDescription)
            }
        }
    }
}
