//
//  AsyncAvatarViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

@MainActor
@Observable class AsyncAvatarViewModel {

    func loadImage(named name: String, urlString: String?) async -> UIImage {
        if let localImage = UIImage(named: name) {
            return localImage
        }

        if let urlString = urlString,
              let url = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let downloadedImage = UIImage(data: data) {
               return downloadedImage
           }

        return UIImage(named: "defaultAvatar") ?? UIImage()
    }
}
