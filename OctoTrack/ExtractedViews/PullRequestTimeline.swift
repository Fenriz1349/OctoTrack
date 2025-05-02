//
//  PullRequestTimeline.swift
//  OctoTrack
//
//  Created by Julien Cotte on 02/05/2025.
//

import SwiftUI

//struct PullRequestTimeline: View {
//    let pullRequest: PullRequest
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Text("timeline".localized)
//                .font(.headline)
//                .padding(.bottom, 8)
//            
//            TimelineEvent(
//                date: pullRequest.createdAt,
//                status: .created,
//                isFirst: true,
//                isLast: pullRequest.closedAt == nil && pullRequest.mergedAt == nil
//            )
//            
//            if let updateDate = pullRequest.updateAt {
//                TimelineEvent(
//                    date: updateDate,
//                    status: .updated,
//                    isFirst: false,
//                    isLast: pullRequest.closedAt == nil && pullRequest.mergedAt == nil
//                )
//            }
//            
//            if let mergedDate = pullRequest.mergedAt {
//                TimelineEvent(
//                    date: mergedDate,
//                    status: .merged,
//                    isFirst: false,
//                    isLast: true
//                )
//            } else if let closedDate = pullRequest.closedAt {
//                TimelineEvent(
//                    date: closedDate,
//                    status: .closed,
//                    isFirst: false,
//                    isLast: true
//                )
//            }
//        }
//    }
//}
//
//#Preview {
//    PullRequestTimeline(pullRequest: PreviewPullRequests.architecturePRs.first!)
//}
