import UIKit

// MARK: - TrackerChoosingScreenController
final class TrackerChoosingScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private let analyticsService = AnalyticsService()

    private let titleLabel = UICreator.shared.makeLabel(text: "TRACKER_CREATION".localized,
                                                        font: UIFont.appFont(.medium, withSize: 16))
    private let stackView = UICreator.shared.makeStackView()
    private let habitButton = UICreator.shared.makeButton(withTitle: "HABIT".localized,
                                                          action: #selector(habitButtonTapped))
    private let eventButton = UICreator.shared.makeButton(withTitle: "NONREGULAR_EVENT".localized,
                                                          action: #selector(eventButtonTapped))

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        setupAutolayout()
        addSubviews()
        setupConstraints()
        analyticsService.report(event: K.AnalyticEventNames.click,
                                params: ["screen": K.AnalyticScreenNames.trackers,
                                         "item": K.AnalyticItemNames.addTrack])

        analyticsService.report(event: K.AnalyticEventNames.open,
                                params: ["screen": K.AnalyticScreenNames.trackerChoosing,
                                         "item": K.AnalyticItemNames.none])
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let topController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let destinationViewController = topController.children.first?.children.first as? TrackersScreenController
            destinationViewController?.updateCollectionView()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: K.AnalyticEventNames.close,
                                params: ["screen": K.AnalyticScreenNames.trackerChoosing,
                                         "item": K.AnalyticItemNames.none])
    }
}

// MARK: - Helpers
extension TrackerChoosingScreenController {

    @objc private func habitButtonTapped() {
        analyticsService.report(event: K.AnalyticEventNames.click,
                                params: ["screen": K.AnalyticScreenNames.trackerChoosing,
                                         "item": K.AnalyticItemNames.habit])
        present(HabitCreationScreenController(), animated: true)
    }

    @objc private func eventButtonTapped() {
        analyticsService.report(event: K.AnalyticEventNames.click,
                                params: ["screen": K.AnalyticScreenNames.trackerChoosing,
                                         "item": K.AnalyticItemNames.event])
        present(HabitCreationScreenController(isNonRegularEvent: true), animated: true)
    }

    private func setupAutolayout() {
        titleLabel.toAutolayout()
        stackView.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        stackView.addArrangedSubview(habitButton)
        stackView.addArrangedSubview(eventButton)
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
