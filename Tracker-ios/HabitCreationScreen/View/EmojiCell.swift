import UIKit

// MARK: - EmojiCell
final class EmojiCell: UICollectionViewCell {

    // MARK: - Properties and Initializers
    var frameView: UIView = {
        let uiView = UICreator.shared.makeView()
        uiView.layer.cornerRadius = 8
        uiView.layer.masksToBounds = true
        uiView.backgroundColor = .ypGrayField
        uiView.isHidden = true
        return uiView
    }()

    var emojiIcon = UICreator.shared.makeLabel(font: UIFont.appFont(.bold, withSize: 32))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Helpers
extension EmojiCell {

    private func setupAutolayout() {
        frameView.toAutolayout()
        emojiIcon.toAutolayout()
    }

    private func addSubviews() {
        addSubview(frameView)
        addSubview(emojiIcon)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            frameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameView.topAnchor.constraint(equalTo: topAnchor),
            frameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emojiIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
