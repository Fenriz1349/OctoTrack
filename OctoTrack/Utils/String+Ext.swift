//
//  String+Ext.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

extension String {
    static func localized(_ key: LK) -> String {
        NSLocalizedString(key.rawValue, comment: "")
    }
}
