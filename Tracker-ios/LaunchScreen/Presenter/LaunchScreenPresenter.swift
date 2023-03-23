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
        print(123)
        print(UserDefaultsManager.shared.isOnboardAccepted)
        if UserDefaultsManager.shared.isOnboardAccepted {
            print("accepted")
        } else {
            print("declined")
        }
    }
}
