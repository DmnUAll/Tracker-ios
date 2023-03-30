import UIKit

// MARK: - ScheduleConfigurationScreenViewDelegate protocol
protocol ScheduleConfigurationScreenViewDelegate: AnyObject {
    func applySchedule()
}

// MARK: - ScheduleConfigurationScreenView
final class ScheduleConfigurationScreenView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: ScheduleConfigurationScreenViewDelegate?

    let titleLabel = UICreator.shared.makeLabel(text: "Расписание",
                                                        font: UIFont.appFont(.medium, withSize: 16))

    let daysTableView: UITableView = {
        let tableView = UICreator.shared.makeTableView()
        tableView.register(DaySelectionCell.self,
                           forCellReuseIdentifier: K.CollectionElementNames.daySelectionCell)
        tableView.backgroundColor = .ypWhite
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    let doneButton = UICreator.shared.makeButton(withTitle: "Готово",
                                                        action: #selector(doneButtonTapped))

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
extension ScheduleConfigurationScreenView {

    @objc private func doneButtonTapped() {
        delegate?.applySchedule()
    }

    private func setupAutolayout() {
        toAutolayout()
        titleLabel.toAutolayout()
        daysTableView.toAutolayout()
        doneButton.toAutolayout()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(daysTableView)
        addSubview(doneButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            daysTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            daysTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            daysTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            daysTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
