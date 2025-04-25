//
//  PreviewPullRequests.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import Foundation

enum PreviewPullRequests {
    // Pull requests pour OctoTrack (id: 0)
    static let octoTrackPRs: [PullRequest] = [
        PullRequest(
            id: 10001,
            number: 1,
            state: "closed",
            title: "Configuration initiale du projet et authentification OAuth",
            createdAt: Date().addingTimeInterval(-2500000),
            updateAt: Date().addingTimeInterval(-2450000),
            closedAt: Date().addingTimeInterval(-2400000),
            mergedAt: Date().addingTimeInterval(-2400000),
            isDraft: false
        ),
        PullRequest(
            id: 10002,
            number: 2,
            state: "closed",
            title: "Implémentation du modèle de données SwiftData",
            createdAt: Date().addingTimeInterval(-2200000),
            updateAt: Date().addingTimeInterval(-2180000),
            closedAt: Date().addingTimeInterval(-2150000),
            mergedAt: Date().addingTimeInterval(-2150000),
            isDraft: false
        ),
        PullRequest(
            id: 10003,
            number: 3,
            state: "closed",
            title: "Ajout des endpoints API GitHub",
            createdAt: Date().addingTimeInterval(-1800000),
            updateAt: Date().addingTimeInterval(-1750000),
            closedAt: Date().addingTimeInterval(-1700000),
            mergedAt: Date().addingTimeInterval(-1700000),
            isDraft: false
        ),
        PullRequest(
            id: 10004,
            number: 4,
            state: "open",
            title: "Interface utilisateur pour la liste des repositories",
            createdAt: Date().addingTimeInterval(-800000),
            updateAt: Date().addingTimeInterval(-400000),
            closedAt: nil,
            mergedAt: nil,
            isDraft: false
        ),
        PullRequest(
            id: 10005,
            number: 5,
            state: "open",
            title: "Ajout de fonctionnalités de recherche",
            createdAt: Date().addingTimeInterval(-300000),
            updateAt: Date().addingTimeInterval(-200000),
            closedAt: nil,
            mergedAt: nil,
            isDraft: true
        ),
        PullRequest(
            id: 10006,
            number: 6,
            state: "open",
            title: "Intégration des pull requests dans l'application",
            createdAt: Date().addingTimeInterval(-100000),
            updateAt: Date().addingTimeInterval(-50000),
            closedAt: nil,
            mergedAt: nil,
            isDraft: false
        )
    ]

    // Pull requests pour iOS-Architecture (id: 1)
    static let architecturePRs: [PullRequest] = [
        PullRequest(
            id: 20001,
            number: 1,
            state: "closed",
            title: "Exemple d'application MVVM basique",
            createdAt: Date().addingTimeInterval(-5000000),
            updateAt: Date().addingTimeInterval(-4950000),
            closedAt: Date().addingTimeInterval(-4900000),
            mergedAt: Date().addingTimeInterval(-4900000),
            isDraft: false
        ),
        PullRequest(
            id: 20002,
            number: 2,
            state: "closed",
            title: "Ajout d'un exemple Clean Architecture",
            createdAt: Date().addingTimeInterval(-4500000),
            updateAt: Date().addingTimeInterval(-4450000),
            closedAt: Date().addingTimeInterval(-4400000),
            mergedAt: Date().addingTimeInterval(-4400000),
            isDraft: false
        ),
        PullRequest(
            id: 20003,
            number: 3,
            state: "closed",
            title: "Intégration de SwiftUI avec MVVM",
            createdAt: Date().addingTimeInterval(-3500000),
            updateAt: Date().addingTimeInterval(-3400000),
            closedAt: Date().addingTimeInterval(-3300000),
            mergedAt: Date().addingTimeInterval(-3300000),
            isDraft: false
        ),
        PullRequest(
            id: 20004,
            number: 4,
            state: "closed",
            title: "Exemple d'utilisation de Combine avec MVVM",
            createdAt: Date().addingTimeInterval(-2500000),
            updateAt: Date().addingTimeInterval(-2400000),
            closedAt: Date().addingTimeInterval(-2300000),
            mergedAt: Date().addingTimeInterval(-2300000),
            isDraft: false
        )
    ]

    // Pull requests pour NetworkLayer (id: 2)
    static let networkLayerPRs: [PullRequest] = []

    // Pull requests pour SwiftConcurrency (id: 3)
    static let concurrencyPRs: [PullRequest] = [
        PullRequest(
            id: 40001,
            number: 1,
            state: "closed",
            title: "Configuration initiale et exemples de base",
            createdAt: Date().addingTimeInterval(-1200000),
            updateAt: Date().addingTimeInterval(-1150000),
            closedAt: Date().addingTimeInterval(-1100000),
            mergedAt: Date().addingTimeInterval(-1100000),
            isDraft: false
        ),
        PullRequest(
            id: 40002,
            number: 2,
            state: "closed",
            title: "Exemples d'async/await",
            createdAt: Date().addingTimeInterval(-1000000),
            updateAt: Date().addingTimeInterval(-950000),
            closedAt: Date().addingTimeInterval(-900000),
            mergedAt: Date().addingTimeInterval(-900000),
            isDraft: false
        ),
        PullRequest(
            id: 40003,
            number: 3,
            state: "closed",
            title: "Utilisation des Actors",
            createdAt: Date().addingTimeInterval(-800000),
            updateAt: Date().addingTimeInterval(-750000),
            closedAt: Date().addingTimeInterval(-700000),
            mergedAt: Date().addingTimeInterval(-700000),
            isDraft: false
        ),
        PullRequest(
            id: 40004,
            number: 4,
            state: "closed",
            title: "Exemples de Task et TaskGroup",
            createdAt: Date().addingTimeInterval(-600000),
            updateAt: Date().addingTimeInterval(-550000),
            closedAt: Date().addingTimeInterval(-500000),
            mergedAt: Date().addingTimeInterval(-500000),
            isDraft: false
        ),
        PullRequest(
            id: 40005,
            number: 5,
            state: "open",
            title: "Intégration avec Combine",
            createdAt: Date().addingTimeInterval(-400000),
            updateAt: Date().addingTimeInterval(-350000),
            closedAt: nil,
            mergedAt: nil,
            isDraft: false
        ),
        PullRequest(
            id: 40006,
            number: 6,
            state: "open",
            title: "Gestion avancée des erreurs",
            createdAt: Date().addingTimeInterval(-300000),
            updateAt: nil,
            closedAt: nil,
            mergedAt: nil,
            isDraft: true
        ),
        PullRequest(
            id: 40007,
            number: 7,
            state: "open",
            title: "Exemples de AsyncSequence",
            createdAt: Date().addingTimeInterval(-200000),
            updateAt: nil,
            closedAt: nil,
            mergedAt: nil,
            isDraft: false
        ),
        PullRequest(
            id: 40008,
            number: 8,
            state: "open",
            title: "Structured Concurrency et cancellation",
            createdAt: Date().addingTimeInterval(-100000),
            updateAt: nil,
            closedAt: nil,
            mergedAt: nil,
            isDraft: true
        )
    ]

    // Helper to get pullrequests from a specific repository
    static func getPR(for repository: Repository) -> [PullRequest] {
        switch repository.id {
        case 0:
            return octoTrackPRs
        case 1:
            return architecturePRs
        case 2:
            return networkLayerPRs
        case 3:
            return concurrencyPRs
        default:
            return []
        }
    }
}
