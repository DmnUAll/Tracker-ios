import UIKit

// MARK: - HeaderSupplementaryView
final class HeaderSupplementaryView: UICollectionReusableView {

    // MARK: - Properties and Initializers
    let titleLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.bold, withSize: 19),
                                                color: .ypBlack,
                                                alignment: .left)

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
extension HeaderSupplementaryView {

    private func setupAutolayout() {
        titleLabel.toAutolayout()
    }

    private func addSubviews() {
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
