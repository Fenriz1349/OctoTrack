//
//  AuthenticationMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

enum GitHubAuthenticationMapper {
    
    private struct Root: Decodable {
        let token: String
    }

    static func map(_ data: Data, and response: HTTPURLResponse) throws -> String {
        print("Code de statut HTTP: \(response.statusCode)")
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("Contenu de la réponse: \(responseString)")
        }
        
        guard response.statusCode == 200 else {
            throw Errors.invalidResponse
        }
        
        // Essayez d'abord le décodage JSON standard
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let accessToken = json["access_token"] as? String {
            print("succes du decodage standard")
               return accessToken
           }
        
        // Si le JSON standard échoue, essayez de traiter comme une chaîne de requête
        if let responseString = String(data: data, encoding: .utf8) {
            // Format possible: access_token=gho_XXX&scope=repo,user&token_type=bearer
            let components = responseString.components(separatedBy: "&")
            for component in components {
                let pair = component.components(separatedBy: "=")
                if pair.count == 2 && pair[0] == "access_token" {
                    return pair[1]
                }
            }
        }
        
        throw Errors.missingToken
    }
}
