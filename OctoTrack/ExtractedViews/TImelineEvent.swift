//
//  TImelineEvent.swift
//  OctoTrack
//
//  Created by Julien Cotte on 02/05/2025.
//

import SwiftUI

//struct TimelineEvent: View {
//    let date: Date
//    let status: Status
//    let isFirst: Bool
//    let isLast: Bool
//    
//    var body: some View {
//        HStack(alignment: .top) {
//            ZStack(alignment: .top) {
//                if !isFirst {
//                    Rectangle()
//                        .fill(status.color)
//                        .frame(width: 2)
//                        .frame(height: 24)
//                        .offset(y: -24)
//                }
//                
//                Image(systemName: status.icon)
//                    .foregroundColor(status.color)
//                    .background(Circle().fill(Color.white).frame(width: 18, height: 18))
//                
//                if !isLast {
//                    Rectangle()
//                        .fill(status.color)
//                        .frame(width: 2)
//                        .frame(height: 40)
//                        .offset(y: 18)
//                }
//            }
//            .frame(width: 20)
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(status.value)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                
//                Text(date.formatted(date: .abbreviated, time: .shortened))
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            .padding(.leading, 8)
//            .padding(.bottom, isLast ? 0 : 20)
//        }
//    }
//}
//
//#Preview {
//    TimelineEvent(date: Date(), status: .merged, isFirst: false, isLast: false)
//}
