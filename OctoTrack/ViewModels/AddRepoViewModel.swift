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
//    var repo: Repository?

    private let repoGetter: RepoGetter = RepoGetter()
    
    func getRepo() async -> Repository? {
        do {
            let request = try RepoEndpoint.request(owner: owner, repoName: repoName)
            let repo = try await repoGetter.repoGetter(from: request)

            print("chargement du repo \(repo.name) d'Id \(repo.id)")
            return repo
        } catch {
            print(error)
        }
        return nil
    }
}
