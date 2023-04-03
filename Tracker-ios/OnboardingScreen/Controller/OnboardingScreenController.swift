import UIKit

// MARK: - OnboardingScreenController
final class OnboardingScreenController: UIViewController {

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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Helpers
extension OnboardingScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            onboardingScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
