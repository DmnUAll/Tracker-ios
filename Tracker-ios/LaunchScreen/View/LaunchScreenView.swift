import UIKit

// MARK: - LaunchScreenView
final class LaunchScreenView: UIView {

    // MARK: - Properties and Initializers
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutolayout()
        imageView.image = UIImage(named: K.IconNames.logoIcon)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        toAutolayout()
        addSubview(logoImage)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension LaunchScreenView {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 91),
            logoImage.heightAnchor.constraint(equalToConstant: 94),
            logoImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
