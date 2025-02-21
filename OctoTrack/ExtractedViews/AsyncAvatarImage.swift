//
//  AsyncAvatarImage.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

struct AsyncAvatarImage: View {
    @State private var viewModel = AsyncAvatarViewModel()
    
    let avatar: AvatarProperties
    let size: CGFloat
    
    private var imageToDisplay: Image {
        if let uiImage = viewModel.downloadedImage {
            return Image(uiImage: uiImage)
        } else if let localImage = UIImage(named: avatar.name) {
            return Image(uiImage: localImage)
        } else {
            return Image("defaultAvatar")
        }
    }
    
    var body: some View {
        imageToDisplay
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .task {
                await viewModel.loadImage(from: avatar.url)
            }
    }
}
