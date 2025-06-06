//
//  PriorityButtonsStack.swift
//  OctoTrack
//
//  Created by Julien Cotte on 18/04/2025.
//

import SwiftUI

struct PriorityButtonsStack: View {
    @Binding var selectedPriority: RepoPriority
    var showAll: Bool = false
    var priorities: [RepoPriority] {
        showAll ? RepoPriority.allCases: RepoPriority.allCases.filter { $0.rawValue != 0 }
    }

    var body: some View {
            HStack {
                ForEach(priorities, id: \.rawValue) { priority in
                    Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedPriority = priority
                            }
                        }, label: {
                            CustomButtonLabel(
                                iconLeading: priority.icon,
                                message: priority.name,
                                color: priority.color,
                                isSelected: selectedPriority == priority,
                                fontSize: 12
                            )
                        }
                    )
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}

#Preview {
    PriorityButtonsStack(selectedPriority: .constant(.low))
}
