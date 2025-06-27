//
//  AddRepoViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

@MainActor
final class AddRepoViewModel: ObservableObject {

    enum Feedback: FeedbackHandler, Equatable {
        case none
        case addSuccess(owner: String, repoName: String)
        case alreadyTracked(owner: String, repoName: String)
        case addFailed(owner: String, repoName: String, error: String)

        var message: String? {
            switch self {
            case .none: return nil
            case .addSuccess(let owner, let repoName):
                return String(localized: "addSuccess \(owner)/\(repoName)")
            case .alreadyTracked(let owner, let repoName):
                return String(localized: "\(owner)/\(repoName) alreadyTracked ")
            case .addFailed(let owner, let repoName, let error):
                return String(localized: "addFail \(owner)/\(repoName): \(error)")
            }
        }

        var isError: Bool {
            switch self {
            case .none, .alreadyTracked, .addSuccess: return false
            case .addFailed: return true
            }
        }
    }

    @Published var owner: String
    @Published var repoName: String = ""
    @Published var priority: RepoPriority = .low
    @Published var feedback: Feedback = .none
    @Published var isLoading = false
    @Published var shouldDismissModal = false

    let dataManager: UserDataManager
    private let repoGetter: RepoGetter = RepoGetter()
    private let authenticator = GitHubAuthenticator()

    var isFormValid: Bool {
        !owner.isEmpty && !repoName.isEmpty
    }

    var shouldShowFeedback: Bool {
        feedback != .none
    }

    init(dataManager: UserDataManager) {
        self.dataManager = dataManager
        self.owner = dataManager.activeUser?.login ?? ""
    }

    func getRepo() async {
        isLoading = true

        do {
            let token = try await authenticator.retrieveToken()
            let request = try RepoEndpoint.request(owner: owner, repoName: repoName, token: token)
            let repo = try await repoGetter.repoGetter(from: request)

            if let currentUser = dataManager.activeUser,
               currentUser.repoList.contains(where: { $0.id == repo.id }) {
                feedback = .alreadyTracked(owner: owner, repoName: repoName)
                isLoading = false
                return
            }

            repo.priority = priority
            try dataManager.storeNewRepo(repo)
            feedback = .addSuccess(owner: owner, repoName: repoName)
            isLoading = false
        } catch {
            feedback = .addFailed(owner: owner, repoName: repoName, error: error.localizedDescription)
            isLoading = false
        }
    }

    func resetFeedback() {
        feedback = .none
    }
}
