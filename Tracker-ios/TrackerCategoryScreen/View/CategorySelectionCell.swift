import UIKit

// MARK: - CategorySelectionCell
final class CategorySelectionCell: UITableViewCell {

    // MARK: - Properties and Initializers
    let categoryLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.regular, withSize: 17),
                                                   alignment: .natural)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Helpers
extension CategorySelectionCell {

    private func setupAutolayout() {
        categoryLabel.toAutolayout()
    }

    private func addSubviews() {
        addSubview(categoryLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -41),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26)
        ])
    }
}
