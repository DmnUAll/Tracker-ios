import UIKit

// MARK: - OnboardingPageController
final class OnboardingPageController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let onboardingPageView = OnboardingPageView()

    convenience init(text: String, backgroundImage: UIImage) {
        self.init()
        onboardingPageView.infoLabel.text = text
        onboardingPageView.backgroundImage.image = backgroundImage
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypBlue
        view.addSubview(onboardingPageView)
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Helpers
extension OnboardingPageController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            onboardingPageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingPageView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingPageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingPageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
