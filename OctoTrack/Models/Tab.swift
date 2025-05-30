//
//  Tab.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import SwiftUI

enum Tab: CaseIterable, Identifiable {
    case repoList
    case addRepo
    case account
    var id: Self { self }

    var tabIcon: IconsName {
        switch self {
        case .account: .person
        case .addRepo: .plus
        case .repoList: .folder
        }
    }

    var tabLabel: String {
        switch self {
        case .account: String(localized: "account")
        case .addRepo: String(localized: "repoAdd")
        case .repoList: String(localized: "repoList")
        }
    }

    func tabItem() -> some View {
        Label(tabLabel, systemImage: tabIcon.rawValue)
    }
}
