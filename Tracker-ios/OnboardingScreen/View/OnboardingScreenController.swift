import UIKit

// MARK: - OnboardingScreenController
final class OnboardingScreenController: UIPageViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private var viewModel: OnboardingScreenViewModel?

    private let pageControl = UICreator.shared.makePageControll()
    private let continueButton = UICreator.shared.makeButton(withTitle: "WHAT_A_TECHNOLOGY".localized,
                                                             action: #selector(continueButtonTapped))

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypBlue
        setupAutolayout()
        addSubviews()
        setupConstraints()
        viewModel = OnboardingScreenViewModel()
        dataSource = self
        delegate = self
        if let firstPage = viewModel?.giveFirstPage() {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - Helpers
extension OnboardingScreenController {

    @objc private func continueButtonTapped() {
        viewModel?.acceptOnboarding()
        UIApplication.shared.windows.first?.rootViewController = TabBarController()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    private func setupAutolayout() {
        pageControl.toAutolayout()
        continueButton.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(pageControl)
        view.addSubview(continueButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingScreenController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        viewModel?.giveViewControllerBefore(viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        viewModel?.giveViewControllerAfter(viewController)
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
           let currentIndex = viewModel?.giveIndex(for: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
