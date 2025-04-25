//
//  RepolistViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 11/04/2025.
//

import SwiftUI

@MainActor
@Observable final class RepoListViewModel {
    let dataManager: UserDataManager

    var activeUser: User? {
        dataManager.activeUser
    }

    init(dataManager: UserDataManager) {
        self.dataManager = dataManager
    }

    func deleteRepository(_ repo: Repository) {
        withAnimation {
            dataManager.deleteRepo(id: repo.id)
        }
    }

    func orderRepositories() {
        withAnimation {
            dataManager.orderRepositories()
        }
    }
}
