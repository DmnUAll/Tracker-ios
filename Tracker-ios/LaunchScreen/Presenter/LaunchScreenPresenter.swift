import UIKit

// MARK: - LaunchScreenPresenter
final class LaunchScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: LaunchScreenController?

    init(viewController: LaunchScreenController? = nil) {
        self.viewController = viewController
        checkIfNeedToShowOnboarding()
    }
}

// MARK: - Helpers
extension LaunchScreenPresenter {

    func checkIfNeedToShowOnboarding() {
        if UserDefaultsManager.shared.isOnboardAccepted {
            UIApplication.shared.windows.first?.rootViewController = TabBarController()
        } else {
            UIApplication.shared.windows.first?.rootViewController = OnboardingScreenController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
        }
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
