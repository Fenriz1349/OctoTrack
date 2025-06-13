//
//  AsyncAvatarImage.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

struct AsyncAvatarImage: View {
    @State private var image: UIImage = UIImage()
    let avatarName: String
    let avatarUrl: String
    let size: CGFloat

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .task {
                image = await loadImage(named: avatarName, urlString: avatarUrl)
            }
    }
    
    private func loadImage(named name: String, urlString: String?) async -> UIImage {
        if let localImage = UIImage(named: name) {
            return localImage
        }

        if let urlString = urlString,
              let url = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let downloadedImage = UIImage(data: data) {
               return downloadedImage
           }

        return UIImage(named: "AppLogo") ?? UIImage()
    }
}
