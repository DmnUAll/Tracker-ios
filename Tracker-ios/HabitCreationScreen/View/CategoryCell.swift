import UIKit

// MARK: - CategoryCell
final class CategoryCell: UITableViewCell {

    // MARK: - Properties and Initializers
    private let stackView = UICreator.shared.makeStackView()
    private let titleLabel = UICreator.shared.makeLabel(text: "Категория", font: UIFont.appFont(.regular, withSize: 17))
    let infoLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.regular, withSize: 17), color: .ypGray)

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
extension CategoryCell {

    private func setupAutolayout() {
        stackView.toAutolayout()
    }

    private func addSubviews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(infoLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }
}
