import UIKit

// MARK: - ScheduleConfigurationDelegate protocol
protocol ScheduleConfigurationDelegate: AnyObject {
    var previousSelectedSchedule: [String] { get }
    func updateSchedule(withDays days: [String])
}

// MARK: - ScheduleConfigurationScreenController
final class ScheduleConfigurationScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private var viewModel: ScheduleConfigurationScreenViewModel?
    weak var delegate: ScheduleConfigurationDelegate?
    private let analyticsService = AnalyticsService()

    private let titleLabel = UICreator.shared.makeLabel(text: "SCHEDULE".localized,
                                                        font: UIFont.appFont(.medium, withSize: 16))

    private let daysTableView: UITableView = {
        let tableView = UICreator.shared.makeTableView()
        tableView.register(DaySelectionCell.self,
                           forCellReuseIdentifier: K.CollectionElementNames.daySelectionCell)
        tableView.backgroundColor = .ypWhite
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let doneButton = UICreator.shared.makeButton(withTitle: "DONE".localized,
                                                        action: #selector(doneButtonTapped))

    convenience init(delegate: ScheduleConfigurationDelegate?) {
        self.init()
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        setupAutolayout()
        addSubviews()
        setupConstraints()
        viewModel = ScheduleConfigurationScreenViewModel()
        viewModel?.selectPreviouslyChoosenSchedule(withDays: delegate?.previousSelectedSchedule ?? [])
        daysTableView.dataSource = self
        daysTableView.delegate = self
        analyticsService.report(event: K.AnalyticEventNames.open,
                                params: ["screen": K.AnalyticScreenNames.scheduleConfiguration,
                                         "item": K.AnalyticItemNames.none])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: K.AnalyticEventNames.close,
                                params: ["screen": K.AnalyticScreenNames.scheduleConfiguration,
                                         "item": K.AnalyticItemNames.none])
    }
}

// MARK: - Helpers
extension ScheduleConfigurationScreenController {

    @objc private func doneButtonTapped() {
        analyticsService.report(event: K.AnalyticEventNames.click,
                                params: ["screen": K.AnalyticScreenNames.scheduleConfiguration,
                                         "item": K.AnalyticItemNames.confirmSchedule])
        delegate?.updateSchedule(withDays: viewModel?.giveSelectedDays() ?? [])
        dismiss(animated: true)
    }

    private func setupAutolayout() {
        titleLabel.toAutolayout()
        daysTableView.toAutolayout()
        doneButton.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(daysTableView)
        view.addSubview(doneButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            daysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            daysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            daysTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ScheduleConfigurationScreenController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.giveNumberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ScheduleConfigurationScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
