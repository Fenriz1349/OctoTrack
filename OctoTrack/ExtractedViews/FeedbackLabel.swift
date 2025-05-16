//
//  FeedbackLabel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 07/03/2025.
//

import SwiftUI

struct FeedbackLabel: View {
    let feedback: FeedbackHandler
    var showIcon: Bool = true

    private var color: Color {
        feedback.isError ? .red : .green
    }

    private var iconName: String {
        feedback.isError ? IconsName.xMark.rawValue : IconsName.checkMark.rawValue
    }

    var body: some View {
        HStack {
            if showIcon {
                Image(systemName: iconName)
                    .foregroundColor(color)
            }
            Text(LocalizedStringKey(feedback.message ?? ""))
                .fontWeight(.medium)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    FeedbackLabel(feedback: PreviewContainer.previewFeedbackSuceess)
}
