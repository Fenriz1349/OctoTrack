//
//  RepoHeaderViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/06/2025.
//

import Foundation

struct RepoHeaderViewModel {
    let repository: Repository
    var openPRCount: Int {
        repository.pullRequests.filter { $0.state == .open }.count
    }

    var closedPRCount: Int {
        repository.pullRequests.filter { $0.state == .closed }.count
    }

    var mergedPRCount: Int {
        repository.pullRequests.filter { $0.state == .merged }.count
    }

    var totalPRCount: Int {
        repository.pullRequests.count
    }
}
