//
//  AppVC.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import SwiftUI

@Observable final class AppViewModel {

    var username: String = "Fenriz1349"
    var userApp: User?
    var isLoogged: Bool = false

    private let userRequest: UserLoader = UserLoader()
    init() {
        Task {
            await getUser()
        }
    }
    
    func getUser() async {
        do {
            let request = try UserEndpoint.request(with: username)
            let user = try await userRequest.userLoader(from: request)

            userApp = User(id: user.id, login: user.login, avatarURL: user.avatarURL, repoList: user.repoList)
            print("chargement du user \(userApp?.login)")
        } catch {
            print(error)
        }
    }
    
    func addRepoToUser(repo: Repository) {
        guard let user = userApp, !user.repoList.contains(where: { $0.id == repo.id }) else {
            return
        }
        userApp?.repoList.append(repo)
    }
}
