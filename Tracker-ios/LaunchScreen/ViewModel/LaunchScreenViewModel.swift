//
//  LaunchScreenViewModel.swift
//  Tracker-ios
//
//  Created by Илья Валито on 22.04.2023.
//

import Foundation

// MARK: - LaunchScreenViewModel
final class LaunchScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable
    private(set) var isOnboardingAccepted: Bool = false
}

// MARK: - Helpers
extension LaunchScreenViewModel {

    func checkIfNeedToShowOnboarding() {
        isOnboardingAccepted = UserDefaultsManager.shared.isOnboardAccepted
    }
}
