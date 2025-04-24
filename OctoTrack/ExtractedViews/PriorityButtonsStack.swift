//
//  PriorityButtonsStack.swift
//  OctoTrack
//
//  Created by Julien Cotte on 18/04/2025.
//

import SwiftUI

struct PriorityButtonsStack: View {
    @Binding var selectedPriority: RepoPriority

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("priority".localized)
                .fontWeight(.bold)
                .padding(.horizontal, 4)
            HStack {
                ForEach(RepoPriority.allCases, id: \.rawValue) { priority in
                    Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedPriority = priority
                            }
                        }, label: {
                            CustomButtonLabel(
                                icon: priority.icon,
                                message: priority.name,
                                color: priority.color,
                                isSelected: selectedPriority == priority
                            )
                        }
                    )
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

#Preview {
    PriorityButtonsStack(selectedPriority: .constant(.low))
}
