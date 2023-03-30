import UIKit

// MARK: - TrackerCellDelegate protocol
protocol TrackerCellDelegate: AnyObject {
    func proceedTask(forID trackerID: UUID)
}

// MARK: - TrackerCell
final class TrackerCell: UICollectionViewCell {

    // MARK: - Properties and Initializers
    weak var delegate: TrackerCellDelegate?
    var trackerID: UUID?

    let taskView: UIView = {
        let uiView = UICreator.shared.makeView()
        uiView.layer.masksToBounds = true
        uiView.layer.cornerRadius = 16
        return uiView
    }()
    let taskIcon: UILabel = {
        let label = UICreator.shared.makeLabel(font: UIFont.appFont(.medium, withSize: 14))
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        label.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        return label
    }()
    let taskName = UICreator.shared.makeLabel(font: UIFont.appFont(.medium, withSize: 12),
                                              color: .ypWhite,
                                              alignment: .natural)
    let counterLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.medium, withSize: 12),
                                                  color: .ypBlack)
    let counterButton: UIButton = {
        let button = UICreator.shared.makeButton(action: #selector(counterButtonTapped))
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.isAccessibilityElement = true
        return button
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
extension TrackerCell {

    @objc private func counterButtonTapped() {
        if let trackerID = trackerID {
            delegate?.proceedTask(forID: trackerID)
        }
    }

    private func setupAutolayout() {
        taskView.toAutolayout()
        taskIcon.toAutolayout()
        taskName.toAutolayout()
        counterLabel.toAutolayout()
        counterButton.toAutolayout()
    }

    private func addSubviews() {
        taskView.addSubview(taskIcon)
        taskView.addSubview(taskName)
        addSubview(taskView)
        addSubview(counterLabel)
        addSubview(counterButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskView.heightAnchor.constraint(equalToConstant: 90),
            taskView.leadingAnchor.constraint(equalTo: leadingAnchor),
            taskView.topAnchor.constraint(equalTo: topAnchor),
            taskView.trailingAnchor.constraint(equalTo: trailingAnchor),
            taskIcon.widthAnchor.constraint(equalToConstant: 24),
            taskIcon.heightAnchor.constraint(equalTo: taskIcon.widthAnchor, multiplier: 1),
            taskIcon.leadingAnchor.constraint(equalTo: taskView.leadingAnchor, constant: 12),
            taskIcon.topAnchor.constraint(equalTo: taskView.topAnchor, constant: 12),
            taskName.leadingAnchor.constraint(equalTo: taskView.leadingAnchor, constant: 12),
            taskName.topAnchor.constraint(greaterThanOrEqualTo: taskView.topAnchor, constant: 44),
            taskName.trailingAnchor.constraint(equalTo: taskView.trailingAnchor, constant: -12),
            taskName.bottomAnchor.constraint(equalTo: taskView.bottomAnchor, constant: -12),
            counterButton.widthAnchor.constraint(equalToConstant: 34),
            counterButton.heightAnchor.constraint(equalTo: counterButton.widthAnchor, multiplier: 1),
            counterButton.topAnchor.constraint(equalTo: taskView.bottomAnchor, constant: 8),
            counterButton.trailingAnchor.constraint(equalTo: taskView.trailingAnchor, constant: -12),
            counterLabel.leadingAnchor.constraint(equalTo: taskView.leadingAnchor, constant: 12),
            counterLabel.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor)
        ])
    }
}
