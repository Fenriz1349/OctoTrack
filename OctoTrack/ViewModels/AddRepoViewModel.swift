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
    private var modelContext: ModelContext?
    private var appViewModel: AppViewModel?
    private let repoGetter: RepoGetter = RepoGetter()
    private let authenticator = GitHubAuthenticator()

    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func setAppViewModel(_ appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
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
    
    func addRepoToUser(repo: Repository) {
        
        guard let appViewModel = appViewModel else {
            feedbackMessage = "AddRepoError".localized
            isSuccess = false
            showFeedback = true
            return
        }
        if let user = appViewModel.userApp,
           !user.repoList.contains(where: {$0.id == repo.id}) {
            user.repoList.append(repo)
            appViewModel.dataManager.saveUser(user)
            feedbackMessage = "addedWithSuccess".localized(repo.name)
            isSuccess = true
        } else {
            feedbackMessage = "failCantAdd".localized
            isSuccess = false
        }
        showFeedback = true
    }
}
