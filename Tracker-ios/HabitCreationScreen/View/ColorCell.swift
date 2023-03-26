import UIKit

// MARK: - ColorCell
final class ColorCell: UICollectionViewCell {

    // MARK: - Properties and Initializers
    let frameView = UICreator.shared.makeView()
    let colorView = UICreator.shared.makeView()

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
        frameView.addSubview(colorView)
        addSubview(frameView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            frameView.widthAnchor.constraint(equalToConstant: 46),
            frameView.heightAnchor.constraint(equalTo: frameView.widthAnchor, multiplier: 1),
            colorView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 3),
            colorView.topAnchor.constraint(equalTo: frameView.topAnchor, constant: 3),
            colorView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -3),
            colorView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -3)
        ])
    }
}
