//
//  PullRequestDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import SwiftUI

struct PullRequestDetailView: View {
    let pullRequest: PullRequest
       let repository: Repository
       
       // Propriétés calculées pour les états du PR
       private var isOpen: Bool {
           return pullRequest.state == .open
       }
       
       private var isMerged: Bool {
           return pullRequest.mergedAt != nil
       }
       
       private var statusColor: Color {
           if isMerged {
               return .purple
           } else if isOpen {
               return .green
           } else {
               return .red
           }
       }
       
       private var statusIcon: String {
           if isMerged {
               return "arrow.triangle.merge"
           } else if isOpen {
               return IconsName.lockOpen.rawValue
           } else {
               return IconsName.lockClose.rawValue
           }
       }
       
       private var statusText: String {
           if isMerged {
               return "merged".localized
           } else if isOpen {
               return "open".localized
           } else {
               return "closed".localized
           }
       }
       
       var body: some View {
           ScrollView {
               VStack(spacing: 16) {
                   // Header compact du repository
                   CompactRepoHeader(repository: repository)
                   
                   // PR Header
                   VStack(alignment: .leading, spacing: 12) {
                       HStack {
                           Text("#\(pullRequest.number)")
                               .font(.headline)
                               .foregroundColor(.secondary)
                           
                           Spacer()
                           
                           // État du PR (ouvert, fermé, fusionné)
                           HStack(spacing: 4) {
                               Image(systemName: statusIcon)
                               Text(statusText)
                                   .font(.caption)
                                   .fontWeight(.medium)
                           }
                           .padding(.horizontal, 8)
                           .padding(.vertical, 4)
                           .background(
                               Capsule()
                                   .fill(statusColor.opacity(0.2))
                           )
                           .foregroundColor(statusColor)
                       }
                       
                       Text(pullRequest.title)
                           .font(.title)
                           .fontWeight(.bold)
                       
                       if pullRequest.isDraft {
                           Text("draft".localized)
                               .font(.caption)
                               .padding(.horizontal, 8)
                               .padding(.vertical, 4)
                               .background(
                                   Capsule()
                                       .fill(Color.gray.opacity(0.2))
                               )
                               .foregroundColor(.gray)
                       }
                       
                       Divider()
                       
                       // Dates
                       VStack(spacing: 8) {
                           DateInfoRow(label: "createdAt".localized, date: pullRequest.createdAt)
                           
                           if let updateDate = pullRequest.updateAt {
                               DateInfoRow(label: "updatedAt".localized, date: updateDate)
                           }
                           
                           if let closedDate = pullRequest.closedAt {
                               DateInfoRow(label: "closedAt".localized, date: closedDate)
                           }
                           
                           if let mergedDate = pullRequest.mergedAt {
                               DateInfoRow(label: "mergedAt".localized, date: mergedDate, color: .purple)
                           }
                       }
                       
                       Divider()
                       
                       // Timeline de l'activité
                       PullRequestTimeline(pullRequest: pullRequest)
                       
                       // Lien vers GitHub
                       Link(destination: URL(string: "https://github.com/\(repository.owner.login)/\(repository.name)/pull/\(pullRequest.number)")!) {
                           HStack {
                               Image(systemName: IconsName.link.rawValue)
                               Text("viewOnGitHub".localized)
                               Spacer()
                               Image(systemName: "arrow.up.right")
                           }
                           .padding()
                           .background(Color.blue.opacity(0.1))
                           .foregroundColor(.blue)
                           .cornerRadius(8)
                       }
                   }
                   .padding()
                   .background(
                       RoundedRectangle(cornerRadius: 12)
                           .fill(Color.white)
                           .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                   )
                   .padding(.horizontal)
               }
               .padding(.vertical)
           }
           .navigationTitle("Pull Request #\(pullRequest.number)")
           .navigationBarTitleDisplayMode(.inline)
       }
   }

   // Header compact pour le repository
   struct CompactRepoHeader: View {
       let repository: Repository
       
       var body: some View {
           VStack(alignment: .leading, spacing: 8) {
               HStack {
                   Text(repository.name)
                       .font(.headline)
                       .fontWeight(.bold)
                   
                   Spacer()
                   
                   LockLabel(status: Status.getRepoStatus(repository))
               }
               
               HStack {
                   AsyncAvatarImage(avatarName: repository.owner.login,
                                   avatarUrl: repository.owner.avatarURL,
                                   size: 24)
                   
                   Text(repository.owner.login)
                       .foregroundColor(.secondary)
                       .font(.subheadline)
                   
                   if let language = repository.language {
                       Spacer()
                       Text(language)
                           .font(.caption)
                           .padding(.horizontal, 8)
                           .padding(.vertical, 4)
                           .background(
                               Capsule()
                                   .fill(Color.gray.opacity(0.2))
                           )
                   }
               }
           }
           .padding()
           .background(
               RoundedRectangle(cornerRadius: 12)
                   .fill(Color.white)
                   .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
           )
           .padding(.horizontal)
       }
   }

   // Ligne de date avec label
   struct DateInfoRow: View {
       let label: String
       let date: Date
       var color: Color = .primary
       
       var body: some View {
           HStack {
               Text(label)
                   .font(.caption)
                   .foregroundColor(.secondary)
                   .frame(width: 80, alignment: .leading)
               
               Text(date.formatted(date: .abbreviated, time: .shortened))
                   .font(.subheadline)
                   .foregroundColor(color)
           }
       }
   }

   // Timeline visuelle pour le PR
   struct PullRequestTimeline: View {
       let pullRequest: PullRequest
       
       var body: some View {
           VStack(alignment: .leading, spacing: 0) {
               Text("timeline".localized)
                   .font(.headline)
                   .padding(.bottom, 8)
               
               // Point de création
               TimelineEvent(
                   date: pullRequest.createdAt,
                   label: "prCreated".localized,
                   icon: "plus.circle.fill",
                   color: .blue,
                   isFirst: true,
                   isLast: pullRequest.closedAt == nil && pullRequest.mergedAt == nil
               )
               
               // Point de mise à jour
               if let updateDate = pullRequest.updateAt { 
                   TimelineEvent(
                       date: updateDate,
                       label: "prUpdated".localized,
                       icon: "arrow.triangle.2.circlepath",
                       color: .orange,
                       isFirst: false,
                       isLast: pullRequest.closedAt == nil && pullRequest.mergedAt == nil
                   )
               }
               
               // Point de fermeture ou de fusion
               if let mergedDate = pullRequest.mergedAt {
                   TimelineEvent(
                       date: mergedDate,
                       label: "prMerged".localized,
                       icon: "arrow.triangle.merge",
                       color: .purple,
                       isFirst: false,
                       isLast: true
                   )
               } else if let closedDate = pullRequest.closedAt {
                   TimelineEvent(
                       date: closedDate,
                       label: "prClosed".localized,
                       icon: "xmark.circle.fill",
                       color: .red,
                       isFirst: false,
                       isLast: true
                   )
               }
           }
       }
   }

   // Un événement dans la timeline
   struct TimelineEvent: View {
       let date: Date
       let label: String
       let icon: String
       let color: Color
       let isFirst: Bool
       let isLast: Bool
       
       var body: some View {
           HStack(alignment: .top) {
               // Ligne verticale et point
               ZStack(alignment: .top) {
                   if !isFirst {
                       Rectangle()
                           .fill(color)
                           .frame(width: 2)
                           .frame(height: 24)
                           .offset(y: -24)
                   }
                   
                   Image(systemName: icon)
                       .foregroundColor(color)
                       .background(Circle().fill(Color.white).frame(width: 18, height: 18))
                   
                   if !isLast {
                       Rectangle()
                           .fill(color)
                           .frame(width: 2)
                           .frame(height: 40)
                           .offset(y: 18)
                   }
               }
               .frame(width: 20)
               
               VStack(alignment: .leading, spacing: 4) {
                   Text(label)
                       .font(.subheadline)
                       .fontWeight(.medium)
                   
                   Text(date.formatted(date: .abbreviated, time: .shortened))
                       .font(.caption)
                       .foregroundColor(.secondary)
               }
               .padding(.leading, 8)
               .padding(.bottom, isLast ? 0 : 20)
           }
       }
   }

#Preview {
    PullRequestDetailView(pullRequest: PreviewPullRequests.architecturePRs.first!, repository: PreviewContainer.previewRepository)
}
