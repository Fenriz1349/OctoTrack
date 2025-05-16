//
//  FeedbackHandler.swift
//  OctoTrack
//
//  Created by Julien Cotte on 16/05/2025.
//

import Foundation

protocol FeedbackHandler {
    var message: String? { get  }
    var isError: Bool { get  }
}
