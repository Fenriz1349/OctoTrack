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
                isStoredInMemoryOnly: true // Important for previews
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
        let dataManager = UserDataManager(modelContext: container.mainContext)

        let viewModel = AppViewModel(dataManager: dataManager)

        viewModel.isLogged = true
        viewModel.isInitializing = false

        let user = populateContainer(container).user

        return viewModel
    }()

    @MainActor
    static func populateContainer(_ container: ModelContainer) -> (user: User, repositories: [Repository]) {
        let context = container.mainContext

        try? context.delete(model: User.self)
        try? context.delete(model: Repository.self)
        try? context.delete(model: Owner.self)
        try? context.delete(model: PullRequest.self)

        context.insert(companyOwner)

        user.isActiveUser = true
        context.insert(user)

        context.insert(userAsOwner)

        for repo in repositories {
            context.insert(repo)
            let pullRequests = PreviewPullRequests.getPR(for: repo)
            for pullRequest in pullRequests {
                context.insert(pullRequest)
                repo.pullRequests.append(pullRequest)
            }
        }

        try? context.save()

        return (user, repositories)
    }

    static let user = User(id: 0, login: "HackerMan",
                    avatarURL: "https://avatars.githubusercontent.com/u/198871564?v=4",
                           repoList: [],
                    lastUpdate: Date())

    static let userAsOwner = user.toOwner()

    static let companyOwner = Owner(id: 1, login: "BatmanInteractive",
                             avatarURL: "https://avatars.githubusercontent.com/u/198871564?v=4")

    static let repositories = [
        Repository(
            id: 0, name: "OctoTrack",
            repoDescription: "Application de suivi de projets GitHub avec authentification OAuth et visualisation.",
            isPrivate: true, owner: userAsOwner,
            createdAt: Date().addingTimeInterval(-2592000),
            updatedAt: Date().addingTimeInterval(-43200),
            language: "Swift",
            priority: .high
        ),
        Repository(
            id: 1, name: "iOS-Architecture",
            repoDescription: "Exemples d'architectures pour le développement iOS: MVVM, Clean Architecture.",
            isPrivate: false, owner: companyOwner,
            createdAt: Date().addingTimeInterval(-5184000),
            updatedAt: Date().addingTimeInterval(-259200),
            language: "Swift",
            priority: .low
        ),
        Repository(
            id: 2, name: "NetworkLayer",
            repoDescription: "Implémentation d'une couche réseau modulaire pour applications iOS modernes.",
            isPrivate: false, owner: companyOwner,
            createdAt: Date().addingTimeInterval(-10368000),
            updatedAt: Date().addingTimeInterval(-1209600),
            language: "Swift",
            priority: .medium
        ),
        Repository(
            id: 3, name: "SwiftConcurrency",
            repoDescription: "Exemples d'utilisation des nouvelles fonctionnalités de concurrence en Swift.",
            isPrivate: true, owner: userAsOwner,
            createdAt: Date().addingTimeInterval(-1296000),
            updatedAt: Date().addingTimeInterval(-86400),
            language: "Swift",
            priority: .low
        )
    ]

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

extension View {
    func previewWithContainer() -> some View {
        self.modelContainer(PreviewContainer.container)
    }
}
