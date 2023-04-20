import UIKit

// MARK: - OnboardingScreenPresenter
final class OnboardingScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: OnboardingScreenController?
    private let pages: [UIViewController] = [
        OnboardingPageController(text: "MONITOR_WHAT_YOU_NEED".localized,
                                 backgroundImage: UIImage(named: K.ImageNames.firstOnboardingImage) ?? UIImage()),
        OnboardingPageController(text: "EVEN_IF_THIS_IS_NOT_YOGA".localized,
                                 backgroundImage: UIImage(named: K.ImageNames.secondOnboardingImage) ?? UIImage())
    ]

    init(viewController: OnboardingScreenController? = nil) {
        self.viewController = viewController
        viewController?.onboardingScreenView.delegate = self
    }
}

// MARK: - Helpers
extension OnboardingScreenPresenter {

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
}

// MARK: - OnboardingScreenViewDelegate
extension OnboardingScreenPresenter: OnboardingScreenViewDelegate {

    func acceptAndProceedToMainScreen() {
        UserDefaultsManager.shared.saveOnboardingState()
        UIApplication.shared.windows.first?.rootViewController = TabBarController()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
