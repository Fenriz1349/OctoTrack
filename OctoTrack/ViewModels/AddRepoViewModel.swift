//
//  AddRepoViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

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

    private let repoGetter: RepoGetter = RepoGetter()
    private let authenticator = GitHubAuthenticator()
#warning("harmoniser les Errors")
    enum RepoError: Error, LocalizedError {
        case emptyFields
        case networkError(Error)
        case notFound

        var errorDescription: String? {
            switch self {
            case .emptyFields:
                return "Le propriétaire et le nom du dépôt sont requis"
            case .networkError(let error):
                return "Erreur réseau: \(error.localizedDescription)"
            case .notFound:
                return "Dépôt introuvable"
            }
        }
    }

    func getRepo() async -> Result<Repository, Error> {

        // Gèrer d'abord si le nom ou le repo est vide
        guard !owner.isEmpty && !repoName.isEmpty else {
            isSuccess = false
            feedbackMessage = "\(owner)/\(repoName)"
            showFeedback = true
            return .failure(RepoError.emptyFields)
        }

        isLoading = true

        do {
            let token = try await authenticator.authenticate()
            let request = try RepoEndpoint.request(owner: owner, repoName: repoName, token: token)
            let repo = try await repoGetter.repoGetter(from: request)

            print("Chargement du repo \(repo.name) d'Id \(repo.id)")
            isSuccess = true
            feedbackMessage = repo.name
            showFeedback = true
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
        showFeedback = false
    }
}
