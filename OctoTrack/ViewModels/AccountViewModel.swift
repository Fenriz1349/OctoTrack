//
//  AccountViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/06/2025.
//

import Foundation

@MainActor
final class AccountViewModel: ObservableObject {
    
    enum Feedback: FeedbackHandler, Equatable {
        case none
        case emptyRepo
        case resetSucessed
        case resetFailed(error: String)

        var message: String? {
            switch self {
            case .none: return nil
            case .emptyRepo: return String(localized: "emptyRepo")
            case .resetSucessed: return String(localized: "resetSuccess")
            case .resetFailed(let error): return String(localized: "resetFailed \(error)")
            }
        }

        var isError: Bool {
            switch self {
            case .resetSucessed: return false
            default: return true
            }
        }
    }

    @Published var showingResetAlert = false
    @Published var feedback : Feedback = .none
    let dataManager: UserDataManager
    let authenticationViewModel: AuthenticationViewModel
    let viewModelFactory: ViewModelFactory
    
    init(dataManager: UserDataManager, authenticationViewModel: AuthenticationViewModel, viewModelFactory: ViewModelFactory) {
        self.dataManager = dataManager
        self.authenticationViewModel = authenticationViewModel
        self.viewModelFactory = viewModelFactory
    }
    
    var shouldShowFeedback: Bool {
        feedback != .none
    }
    
    var repositoryCount: Int {
        return dataManager.activeUser?.repoList.count ?? 0
    }

    func resetButtonTapped() {
        showingResetAlert = checkIfEmptyRepoList()
    }
    
    func signOut() {
        authenticationViewModel.signOut()
    }
    
    func resetFeedback() {
        feedback = .none
    }
    
    func resetUserRepository() {
        do {
            try dataManager.resetAllRepositories()
            feedback = .resetSucessed
        } catch {
            feedback = .resetFailed(error: error.localizedDescription)
        }
    }

    func checkIfEmptyRepoList() -> Bool {
        if let currentUser = dataManager.activeUser, currentUser.repoList.isEmpty {
            feedback = .emptyRepo
            return false
        }
        return  true
    }

    func logoutUser() {
        authenticationViewModel.stopTokenValidation()
        dataManager.deactivateAllUsers()
    }
}
