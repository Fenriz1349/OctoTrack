//
//  AsyncAvatarViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

@MainActor
@Observable class AsyncAvatarViewModel {
    var downloadedImage: UIImage?
    
    func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            return
        }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.downloadedImage = image
                }
            } catch {
                print("Erreur de téléchargement: \(error.localizedDescription)")
            }
        }
    }
}
