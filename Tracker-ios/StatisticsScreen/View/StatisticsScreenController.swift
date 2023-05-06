import UIKit

// MARK: - StatisticsScreenController
final class StatisticsScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private var viewModel: StatisticsScreenViewModel?

    private let noDataImage = UICreator.shared.makeImageView(withImage: K.ImageNames.noDataToAnalyze)
    private let noDataLabel = UICreator.shared.makeLabel(
        text: "NOTHING_TO_ANALYZE".localized,
        font: UIFont.appFont(.medium, withSize: 12))

    private let stackView = UICreator.shared.makeStackView(distribution: .fillEqually, andSpacing: 12)

    private let bestPeriodStackView = UICreator.shared.makeStackView(cornerRadius: 12, andSpacing: 7)
    private let bestPeriodCountLabel = UICreator.shared.makeLabel(text: "-",
                                                                  font: .appFont(.bold, withSize: 34),
                                                                  alignment: .left)
    private let bestPeriodLabel = UICreator.shared.makeLabel(text: "BEST_PERIOD".localized,
                                                             font: .appFont(.medium, withSize: 12),
                                                             alignment: .left)

    private let idealDaysStackView = UICreator.shared.makeStackView(cornerRadius: 12, andSpacing: 7)
    private let idealDaysCountLabel = UICreator.shared.makeLabel(text: "-",
                                                                 font: .appFont(.bold, withSize: 34),
                                                                 alignment: .left)
    private let idealDaysLabel = UICreator.shared.makeLabel(text: "IDEAL_DAYS".localized,
                                                            font: .appFont(.medium, withSize: 12),
                                                            alignment: .left)

    private let trackersCompletedStackView = UICreator.shared.makeStackView(cornerRadius: 12, andSpacing: 7)
    private let trackersCompletedCountLabel = UICreator.shared.makeLabel(text: "-",
                                                                         font: .appFont(.bold, withSize: 34),
                                                                         alignment: .left)
    private let trackersCompletedLabel = UICreator.shared.makeLabel(text: "TRACKERS_COMPLETED".localized,
                                                                    font: .appFont(.medium, withSize: 12),
                                                                    alignment: .left)

    private let averageValueStackView = UICreator.shared.makeStackView(cornerRadius: 12, andSpacing: 7)
    private let averageValueCountLabel = UICreator.shared.makeLabel(text: "-",
                                                                    font: .appFont(.bold, withSize: 34),
                                                                    alignment: .left)
    private let averageValueLabel = UICreator.shared.makeLabel(text: "AVERAGE_VALUE".localized,
                                                               font: .appFont(.medium, withSize: 12),
                                                               alignment: .left)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        setupAutolayout()
        addSubviews()
        setupConstraints()
        hideStatistics()
        viewModel = StatisticsScreenViewModel()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNestedStackViews()
        viewModel?.checkForData()
    }
}

// MARK: - Helpers
extension StatisticsScreenController {

    private func setupAutolayout() {
        noDataImage.toAutolayout()
        noDataLabel.toAutolayout()
        stackView.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(noDataImage)
        view.addSubview(noDataLabel)
        bestPeriodStackView.addArrangedSubview(bestPeriodCountLabel)
        bestPeriodStackView.addArrangedSubview(bestPeriodLabel)
        stackView.addArrangedSubview(bestPeriodStackView)
        idealDaysStackView.addArrangedSubview(idealDaysCountLabel)
        idealDaysStackView.addArrangedSubview(idealDaysLabel)
        stackView.addArrangedSubview(idealDaysStackView)
        trackersCompletedStackView.addArrangedSubview(trackersCompletedCountLabel)
        trackersCompletedStackView.addArrangedSubview(trackersCompletedLabel)
        stackView.addArrangedSubview(trackersCompletedStackView)
        averageValueStackView.addArrangedSubview(averageValueCountLabel)
        averageValueStackView.addArrangedSubview(averageValueLabel)
        stackView.addArrangedSubview(averageValueStackView)
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noDataImage.heightAnchor.constraint(equalToConstant: 80),
            noDataImage.widthAnchor.constraint(equalTo: noDataImage.heightAnchor),
            noDataImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.topAnchor.constraint(equalTo: noDataImage.bottomAnchor, constant: 8),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 396),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$canShowStatistics.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.loadStatistics()
                self.showStatistics()
            } else {
                self.hideStatistics()
            }
        }
    }

    private func hideStatistics() {
        noDataImage.isHidden = false
        noDataLabel.isHidden = false
        stackView.isHidden = true
    }

    private func showStatistics() {
        noDataImage.isHidden = true
        noDataLabel.isHidden = true
        stackView.isHidden = false
    }

    private func configureNestedStackViews() {
        let nestedStackViews = [bestPeriodStackView,
                                idealDaysStackView,
                                trackersCompletedStackView,
                                averageValueStackView]
        nestedStackViews.forEach { stackView in
            stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.gradientBorder(colors: [.ypGradientRed, .ypGradientSky, .ypGradientBlue], isVertical: false)
        }
    }

    private func loadStatistics() {
        trackersCompletedCountLabel.text = viewModel?.giveCompletedTrackersCount() ?? "-"
    }
}
