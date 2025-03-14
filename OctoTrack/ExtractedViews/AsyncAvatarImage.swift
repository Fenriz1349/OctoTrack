//
//  AsyncAvatarImage.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

struct AsyncAvatarImage: View {
    @State private var viewModel = AsyncAvatarViewModel()
    @State private var image: UIImage = UIImage()
    let avatar: AvatarProperties
    let size: CGFloat

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .task {
                image = await viewModel.loadImage(named: avatar.name, urlString: avatar.url)
            }
    }
}
