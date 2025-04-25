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

    private var tabIcon: String {
        switch self {
        case .account: IconsName.person.rawValue
        case .repoList: IconsName.folder.rawValue
        }
    }

    private var tabLabel: String {
        switch self {
        case .account: "account".localized
        case .repoList: "repoList".localized
        }
    }

    func tabItem() -> some View {
        Label(tabLabel, systemImage: tabIcon)
    }
}
