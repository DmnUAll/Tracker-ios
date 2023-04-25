import UIKit

// MARK: - LaunchScreenController
final class LaunchScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private var viewModel: LaunchScreenViewModel?

    private let logoImage: UIImageView = UICreator.shared.makeImageView(withImage: K.IconNames.logoIcon)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypBlue
        setupAutolayout()
        addSubviews()
        setupConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            self.viewModel = LaunchScreenViewModel()
            self.bind()
            self.viewModel?.checkIfNeedToShowOnboarding()
        }
    }
}

// MARK: - Helpers
extension LaunchScreenController {

    private func setupAutolayout() {
        logoImage.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(logoImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 91),
            logoImage.heightAnchor.constraint(equalToConstant: 94),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$isOnboardingAccepted.bind { newValue in
            if newValue {
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
}
