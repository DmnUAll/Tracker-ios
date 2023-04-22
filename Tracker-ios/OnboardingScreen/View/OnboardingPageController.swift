import UIKit

// MARK: - OnboardingPageController
final class OnboardingPageController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private let backgroundImageView = UICreator.shared.makeImageView()
    private let infoLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.bold, withSize: 32))

    convenience init(text: String, backgroundImage: UIImage) {
        self.init()
        infoLabel.text = text
        backgroundImageView.image = backgroundImage
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypBlue
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Helpers
extension OnboardingPageController {

    private func setupAutolayout() {
        backgroundImageView.toAutolayout()
        infoLabel.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(infoLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
            infoLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -304)
        ])
    }
}
