import UIKit

// MARK: - OnboardingScreenPresenter
final class OnboardingScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: OnboardingScreenController?
    private let onboardingTexts = [
        "Отслеживайте только то, что хотите",
        "Даже если это не литры воды и йога"
    ]

    init(viewController: OnboardingScreenController? = nil) {
        self.viewController = viewController
        viewController?.onboardingScreenView.delegate = self
        fillUI()
    }
}

// MARK: - Helpers
extension OnboardingScreenPresenter {

    func fillUI() {
        guard let viewController else { return }
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        for index in 0...1 {
            let text = onboardingTexts[index]
            let scrollViewPage = UICreator.shared.makeView()
            scrollViewPage.frame = CGRect(x: width * CGFloat(index),
                                          y: 0,
                                          width: width,
                                          height: height)
            var imageView: UIImageView
            if index == 0 {
                imageView = UICreator.shared.makeImageView(withImage: K.ImageNames.firstOnboardingImage)
            } else {
                imageView = UICreator.shared.makeImageView(withImage: K.ImageNames.secondOnboardingImage)
            }
            imageView.toAutolayout()
            scrollViewPage.addSubview(imageView)
            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            let label = UICreator.shared.makeLabel(text: text, font: UIFont.appFont(.bold, withSize: 32))
            label.toAutolayout()
            scrollViewPage.addSubview(label)
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16).isActive = true
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16).isActive = true
            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -304).isActive = true
            viewController.onboardingScreenView.scrollView.addSubview(scrollViewPage)
        }
    }
}

// MARK: - OnboardingScreenViewDelegate
extension OnboardingScreenPresenter: OnboardingScreenViewDelegate {

    func acceptAndProceedToMainScreen() {
        UserDefaultsManager.shared.saveOnboardingState()
    }
}
