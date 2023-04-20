import UIKit

// MARK: - OnboardingScreenViewDelegate protocol
protocol OnboardingScreenViewDelegate: AnyObject {
    func acceptAndProceedToMainScreen()
}

// MARK: - OnboardingScreenView
final class OnboardingScreenView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: OnboardingScreenViewDelegate?
    let pageControl = UICreator.shared.makePageControll()
    private let continueButton = UICreator.shared.makeButton(withTitle: "WHAT_A_TECHNOLOGY".localized,
                                                             action: #selector(continueButtonTapped))

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
extension OnboardingScreenView {

    @objc private func continueButtonTapped() {
        delegate?.acceptAndProceedToMainScreen()
    }

    private func setupAutolayout() {
        toAutolayout()
        pageControl.toAutolayout()
        continueButton.toAutolayout()
    }

    private func addSubviews() {
        addSubview(pageControl)
        addSubview(continueButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -84),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24)
        ])
    }
}
