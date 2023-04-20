import UIKit

// MARK: - OnboardingScreenController
final class OnboardingScreenController: UIPageViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let onboardingScreenView = OnboardingScreenView()
    private var presenter: OnboardingScreenPresenter?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypBlue
        view.addSubview(onboardingScreenView)
        setupConstraints()
        presenter = OnboardingScreenPresenter(viewController: self)
        dataSource = self
        delegate = self
        if let firstPage = presenter?.giveFirstPage() {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - Helpers
extension OnboardingScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            onboardingScreenView.heightAnchor.constraint(equalToConstant: 140),
            onboardingScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingScreenController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        presenter?.giveViewControllerBefore(viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        presenter?.giveViewControllerAfter(viewController)
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingScreenController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = presenter?.giveIndex(for: currentViewController) {
            onboardingScreenView.pageControl.currentPage = currentIndex
        }
    }
}
