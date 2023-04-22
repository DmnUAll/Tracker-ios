import UIKit

// MARK: - OnboardingScreenViewModel
final class OnboardingScreenViewModel {

    // MARK: - Properties and Initializers
    private let pages: [UIViewController] = [
        OnboardingPageController(text: "MONITOR_WHAT_YOU_NEED".localized,
                                 backgroundImage: UIImage(named: K.ImageNames.firstOnboardingImage) ?? UIImage()),
        OnboardingPageController(text: "EVEN_IF_THIS_IS_NOT_YOGA".localized,
                                 backgroundImage: UIImage(named: K.ImageNames.secondOnboardingImage) ?? UIImage())
    ]
}

// MARK: - Helpers
extension OnboardingScreenViewModel {

    func giveFirstPage() -> UIViewController? {
        pages.first
    }

    func giveViewControllerBefore(_ viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }

    func giveViewControllerAfter(_ viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }

    func giveIndex(for currentViewController: UIViewController) -> Int? {
        pages.firstIndex(of: currentViewController)
    }

    func acceptOnboarding() {
        UserDefaultsManager.shared.saveOnboardingState()
    }
}
