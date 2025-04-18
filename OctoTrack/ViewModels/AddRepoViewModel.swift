//
//  AddRepoViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation
import SwiftData

@MainActor
@Observable final class AddRepoViewModel {
    var owner: String = "Fenriz1349"
    var repoName: String = "DA-iOS_P5"

    // Pour gérer le feedback dans la view
    var showFeedback = false
    var feedbackMessage = ""
    var isSuccess = false
    var isLoading = false

    var isFormValid: Bool {
            !owner.isEmpty && !repoName.isEmpty
        }
    let dataManager: UserDataManager
    private let repoGetter: RepoGetter = RepoGetter()
    private let authenticator = GitHubAuthenticator()

    init(dataManager: UserDataManager) {
        self.dataManager = dataManager
    }

    func getRepo() async -> Result<Repository, Error> {
        isLoading = true
        do {
            let token = try await authenticator.retrieveToken()
            let request = try RepoEndpoint.request(owner: owner, repoName: repoName, token: token)
            let repo = try await repoGetter.repoGetter(from: request)
            isLoading = false
            return(.success(repo))
        } catch {
            isSuccess = false
            feedbackMessage = "\(owner)/\(repoName)"
            showFeedback = true
            isLoading = false
            return .failure(error)
        }
    }

    func resetFeedback() {
        feedbackMessage = ""
        showFeedback = false
    }
}
