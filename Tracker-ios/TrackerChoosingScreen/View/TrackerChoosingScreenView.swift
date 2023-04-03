import UIKit

// MARK: - TrackerChoosingScreenViewDelegate protocol
protocol TrackerChoosingScreenViewDelegate: AnyObject {
    func proceedToHabit()
    func proceedToEvent()
}

// MARK: - TrackerChoosingScreenView
final class TrackerChoosingScreenView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: TrackerChoosingScreenViewDelegate?

    private let titleLabel = UICreator.shared.makeLabel(text: NSLocalizedString("TRACKER_CREATION", comment: ""),
                                                        font: UIFont.appFont(.medium, withSize: 16))
    private let stackView = UICreator.shared.makeStackView()
    private let habitButton = UICreator.shared.makeButton(withTitle: NSLocalizedString("HABIT", comment: ""),
                                                          action: #selector(habitButtonTapped))
    private let eventButton = UICreator.shared.makeButton(withTitle: NSLocalizedString("NONREGULAR_EVENT", comment: ""),
                                                          action: #selector(eventButtonTapped))

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
extension TrackerChoosingScreenView {

    @objc private func habitButtonTapped() {
        delegate?.proceedToHabit()
    }

    @objc private func eventButtonTapped() {
        delegate?.proceedToEvent()
    }

    private func setupAutolayout() {
        toAutolayout()
        titleLabel.toAutolayout()
        stackView.toAutolayout()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        stackView.addArrangedSubview(habitButton)
        stackView.addArrangedSubview(eventButton)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
