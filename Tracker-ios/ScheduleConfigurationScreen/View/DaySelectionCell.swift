import UIKit

// MARK: - DaySelectionCell
final class DaySelectionCell: UITableViewCell {

    // MARK: - Properties and Initializers
    let dayLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.regular, withSize: 17),
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
extension DaySelectionCell {

    private func setupAutolayout() {
        dayLabel.toAutolayout()
    }

    private func addSubviews() {
        addSubview(dayLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
