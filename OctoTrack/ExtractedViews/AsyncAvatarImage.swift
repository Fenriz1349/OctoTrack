//
//  AsyncAvatarImage.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

struct AsyncAvatarImage: View {
    let user : User
    let size : CGFloat
    
    var body: some View {
            // Vérifier si l'image provient des assets (nom de l'image local)
            if let _ = UIImage(named: imageUrl) {
                Image(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                }
            }
        }
}
