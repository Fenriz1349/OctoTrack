//
//  Tab.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import SwiftUI

enum Tab: CaseIterable, Identifiable {
    case repoList
    case account
    var id: Self { self }

    private var tabIcon: IconsName {
        switch self {
        case .account: .person
        case .repoList: .folder
        }
    }

    private var tabLabel: String {
        switch self {
        case .account: "account"
        case .repoList: "repoList"
        }
    }

    func tabItem() -> some View {
        Label(tabLabel, systemImage: tabIcon.rawValue)
    }
}
