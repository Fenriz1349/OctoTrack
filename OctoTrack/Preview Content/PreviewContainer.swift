//
//  PreviewContainer.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/03/2025.
//

import SwiftData
import SwiftUI

struct PreviewContainer {
    
    @MainActor
    static var container: ModelContainer = {
        do {
            let schema = Schema([
                User.self,
                Owner.self,
                Repository.self,
                PullRequest.self
            ])
            
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true // Important pour les previews
            )
            
            let container = try ModelContainer(for: schema, configurations: [configuration])
            
            populateContainer(container)
            
            return container
        } catch {
            fatalError("Impossible de créer le ModelContainer: \(error)")
        }
    }()
    
    @MainActor
    static var previewAppViewModel: AppViewModel = {
        let viewModel = AppViewModel()
        let user = populateContainer(container).user
        
        viewModel.userApp = user
        viewModel.isLogged = true
        viewModel.isInitializing = false
        
        viewModel.dataManager.setModelContext(container.mainContext)
        
        return viewModel
    }()
    
    @MainActor
    static func populateContainer(_ container: ModelContainer) -> (user: User, repositories: [Repository]) {
        let context = container.mainContext
        
        // Suppression préalable des données existantes pour éviter les doublons
        try? context.delete(model: User.self)
        try? context.delete(model: Repository.self)
        try? context.delete(model: Owner.self)
        
        // Création d'un owner
        let companyOwner = Owner(id: 1, login: "BatmanInteractive", avatarURL: "https://avatars.githubusercontent.com/u/198871564?v=4")
        context.insert(companyOwner)
        
        // Création d'un utilisateur
        let user = User(id: 0,
                        login: "HackerMan",
                        avatarURL: "https://avatars.githubusercontent.com/u/198871564?v=4",
                        repoList: [],
                        lastUpdate: Date())
        user.isActiveUser = true
        context.insert(user)
        
        // Conversion de l'utilisateur en owner pour certains repos
        let userAsOwner = user.toOwner()
        context.insert(userAsOwner)
        
        // Création des repos
        let repositories = [
            Repository(
                id: 0,
                name: "OctoTrack",
                repoDescription: "Application de suivi de projets GitHub avec authentification OAuth et visualisation.",
                isPrivate: true,
                owner: userAsOwner,
                createdAt: Date().addingTimeInterval(-2592000),
                updatedAt: Date().addingTimeInterval(-43200),
                language: "Swift"
            ),
            Repository(
                id: 1,
                name: "iOS-Architecture",
                repoDescription: "Exemples d'architectures pour le développement iOS: MVVM, Clean Architecture.",
                isPrivate: false,
                owner: companyOwner,
                createdAt: Date().addingTimeInterval(-5184000),
                updatedAt: Date().addingTimeInterval(-259200),
                language: "Swift"
            ),
            Repository(
                id: 2,
                name: "NetworkLayer",
                repoDescription: "Implémentation d'une couche réseau modulaire et testable pour applications iOS modernes.",
                isPrivate: false,
                owner: companyOwner,
                createdAt: Date().addingTimeInterval(-10368000),
                updatedAt: Date().addingTimeInterval(-1209600),
                language: "Swift"
            ),
            Repository(
                id: 3,
                name: "SwiftConcurrency",
                repoDescription: "Exemples pratiques d'utilisation des nouvelles fonctionnalités de concurrence en Swift.",
                isPrivate: true,
                owner: userAsOwner,
                createdAt: Date().addingTimeInterval(-1296000),
                updatedAt: Date().addingTimeInterval(-86400),
                language: "Swift"
            )
        ]
        
        // Insertion des repositories dans le contexte
        for repo in repositories {
            context.insert(repo)
        }
        
        // Ajout des repos à l'utilisateur
        user.repoList = repositories
        
        // Sauvegarde du contexte
        try? context.save()
        
        return (user, repositories)
    }
    
    // Fonction pour obtenir facilement un repository spécifique pour les previews
    @MainActor static func getRepository(at index: Int = 0) -> Repository? {
        do {
            let repos = try container.mainContext.fetch(FetchDescriptor<Repository>())
            return repos.count > index ? repos[index] : repos.first
        } catch {
            print("Erreur lors de la récupération du repository: \(error)")
            return nil
        }
    }
}

// Extensions pour faciliter l'utilisation des previews
extension View {
    func previewWithContainer() -> some View {
        self.modelContainer(PreviewContainer.container)
    }
}
