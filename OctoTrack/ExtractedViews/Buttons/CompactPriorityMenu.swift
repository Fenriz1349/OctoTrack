//
//  CompactPriorityMenu.swift
//  OctoTrack
//
//  Created by Julien Cotte on 30/05/2025.
//

import SwiftUI

struct CompactPriorityMenu: View {
    @Bindable var viewModel: RepoDetailsViewModel

    var body: some View {
        Menu {
            ForEach(RepoPriority.allCases.filter {$0 != .all}, id: \.self) { priority in
                Button {
                    viewModel.updateRepositoryPriority(priority)
                } label: {
                    HStack {
                        Image(systemName: priority.icon.rawValue)
                        Text(priority.name)
                    }
                }
            }
        } label: {
            CustomButtonLabel(
                iconLeading: viewModel.repository.priority.icon,
                iconTrailing: IconsName.down,
                message: "",
                color: viewModel.repository.priority.color
            )
        }
        .frame(width: 80)
    }
}
