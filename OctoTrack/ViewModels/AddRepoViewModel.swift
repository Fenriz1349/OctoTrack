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
        case importSuccess(count: Int)
        case addSuccess(owner: String, repoName: String)
        case alreadyTracked(owner: String, repoName: String)
        case addFailed(owner: String, repoName: String, error: String)

        var message: String? {
            switch self {
            case .none: return nil
            case .importSuccess(let count) : return String(localized: "importSucess \(count)")
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
            case .none,.importSuccess, .alreadyTracked, .addSuccess: return false
            case .addFailed: return true
            }
        }
    }

    var owner: String
    var repoName: String = ""
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

    func getRepo() async {
        isLoading = true

        if let currentUser = dataManager.activeUser,
           currentUser.repoList.contains(where: { $0.name == repoName && $0.owner.login == owner }) {
            feedback = .alreadyTracked(owner: owner, repoName: repoName)
            isLoading = false
            return
        }

        do {
            let token = try await authenticator.retrieveToken()
            let request = try RepoEndpoint.request(owner: owner, repoName: repoName, token: token)
            let repo = try await repoGetter.repoGetter(from: request)

            repo.priority = priority
            try dataManager.storeNewRepo(repo)
            try dataManager.modelContext.save()
            feedback = .addSuccess(owner: owner, repoName: repoName)
            isLoading = false
        } catch {
            feedback = .addFailed(owner: owner, repoName: repoName, error: error.localizedDescription)
            isLoading = false
        }
    }
    
    func importAllUserRepos() async {
        isLoading = true
        
        do {
            let token = try await authenticator.retrieveToken()
            let request = try RepoEndpoint.allUserReposRequest(token: token)
            let repos = try await repoGetter.getAllUserRepos(from: request)
            
            for repo in repos {
                try dataManager.storeNewRepo(repo)
            }
            feedback = .importSuccess(count: repos.count)
            isLoading = false
        } catch {
            feedback = .addFailed(owner: "", repoName: "import", error: error.localizedDescription)
            isLoading = false
        }
    }
}
