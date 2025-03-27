//
//  PreviewModels.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import Foundation

struct PreviewModels {
    static var previewUser: User {
        User(id: 2, login: "HackerMan",
             avatarURL: "https://avatars.githubusercontent.com/u/198871564?v=4", repoList: PreviewModels.repositories)
    }
    
    static let compagny = Owner(
        id: 1,
        login: "BatmanInteractive",
        avatarURL: "https://avatars.githubusercontent.com/u/198871564?v=4"
    )
    
    static let previewRepo = Repository(
        id: 1,
        name: "SwiftUI-Components",
        repoDescription: "Une bibliothèque de composants SwiftUI réutilisables pour les applications iOS modernes.",
        isPrivate: false,
        owner: compagny,
        createdAt: Date().addingTimeInterval(-7776000), // ~3 mois dans le passé
        updatedAt: Date().addingTimeInterval(-86400), // Hier
        language: "Swift"
    )
    
    static var repositories: [Repository] {[
        Repository(
            id: 0,
            name: "OctoTrack",
            repoDescription: "Application de suivi de projets GitHub avec authentification OAuth et visualisation de statistiques.",
            isPrivate: true,
            owner: previewUser.toOwner(),
            createdAt: Date().addingTimeInterval(-2592000), // ~1 mois dans le passé
            updatedAt: Date().addingTimeInterval(-43200), // 12 heures dans le passé
            language: nil
        ),
        Repository(
            id: 1,
            name: "iOS-Architecture",
            repoDescription: "Exemples d'architectures pour le développement iOS: MVVM, Clean Architecture, et approches de persistance.",
            isPrivate: false,
            owner: compagny,
            createdAt: Date().addingTimeInterval(-5184000), // ~2 mois dans le passé
            updatedAt: Date().addingTimeInterval(-259200), // 3 jours dans le passé
            language: "Objective-C"
        ),
        Repository(
            id: 2,
            name: "CoreML-Samples",
            repoDescription: "Démonstrations d'intégration de modèles CoreML dans des applications iOS pour la détection d'objets et l'analyse d'images.",
            isPrivate: false,
            owner: compagny,
            createdAt: Date().addingTimeInterval(-7776000), // ~3 mois dans le passé
            updatedAt: Date().addingTimeInterval(-604800), // 1 semaine dans le passé
            language: "Python"
        ),
        Repository(
            id: 3,
            name: "NetworkLayer",
            repoDescription: "Implémentation d'une couche réseau modulaire et testable pour applications iOS modernes.",
            isPrivate: false,
            owner: compagny,
            createdAt: Date().addingTimeInterval(-10368000), // ~4 mois dans le passé
            updatedAt: Date().addingTimeInterval(-1209600), // 2 semaines dans le passé
            language: "Swift"
        ),
        Repository(
            id: 4,
            name: "SwiftConcurrency",
            repoDescription: "Exemples pratiques d'utilisation des nouvelles fonctionnalités de concurrence en Swift: async/await, actors, et structured concurrency.",
            isPrivate: true,
            owner: previewUser.toOwner(),
            createdAt: Date().addingTimeInterval(-1296000), // ~15 jours dans le passé
            updatedAt: Date().addingTimeInterval(-86400), // 1 jour dans le passé
            language: "Swift"
        )
    ]}
}
