import UIKit

// MARK: - ColorCell
final class ColorCell: UICollectionViewCell {

    // MARK: - Properties and Initializers
    var frameView: UIView = {
        let uiView = UICreator.shared.makeView()
        uiView.backgroundColor = .ypWhite
        uiView.layer.cornerRadius = 11
        uiView.layer.masksToBounds = true
        uiView.layer.borderColor = UIColor.clear.cgColor
        return uiView
    }()

    var colorView: UIView = {
        let uiView = UICreator.shared.makeView()
        uiView.layer.cornerRadius = 8
        uiView.layer.masksToBounds = true
        return uiView
    }()

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
extension ColorCell {

    private func setupAutolayout() {
        frameView.toAutolayout()
        colorView.toAutolayout()
    }

    private func addSubviews() {
        addSubview(frameView)
        addSubview(colorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            frameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameView.topAnchor.constraint(equalTo: topAnchor),
            frameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameView.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor, multiplier: 1),
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
