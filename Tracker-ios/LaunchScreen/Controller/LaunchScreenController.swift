import UIKit

// MARK: - LaunchScreenController
final class LaunchScreenController: UIViewController {

    // MARK: - Properties and Initializers
    let launchScreenView = LaunchScreenView()
    private var presenter: LaunchScreenPresenter?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypBlue
        view.addSubview(launchScreenView)
        setupConstraints()
        presenter = LaunchScreenPresenter(viewController: self)
    }
}

// MARK: - Helpers
extension LaunchScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            launchScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            launchScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            launchScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
