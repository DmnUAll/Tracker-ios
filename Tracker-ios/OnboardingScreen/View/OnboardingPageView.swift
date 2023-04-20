import UIKit

// MARK: - OnboardingPageView
final class OnboardingPageView: UIView {

    // MARK: - Properties and Initializers
    let backgroundImage = UICreator.shared.makeImageView()
    let infoLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.bold, withSize: 32))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension OnboardingPageView {

    private func setupAutolayout() {
        toAutolayout()
        backgroundImage.toAutolayout()
        infoLabel.toAutolayout()
    }

    private func addSubviews() {
        addSubview(backgroundImage)
        addSubview(infoLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            backgroundImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
            infoLabel.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -304)
        ])
    }
}
