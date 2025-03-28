//
//  TokenValidator.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/03/2025.
//

import Foundation

class TokenValidator {
    private var timer: Timer?
    private let interval: TimeInterval = 30 * 60 // 30 minutes

    func startPeriodicValidation(onValidation: @escaping () async -> Void) {
        stopPeriodicValidation()

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {_ in
            print("debut timer")
            Task {
                await onValidation()
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
        Task {
            await onValidation()
        }
    }

    func stopPeriodicValidation() {
        timer?.invalidate()
        timer = nil
    }
}
