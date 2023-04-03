import UIKit

// MARK: - ScheduleConfigurationDelegate protocol
protocol ScheduleConfigurationDelegate: AnyObject {
    var previousSelectedSchedule: [String] { get }
    func updateSchedule(withDays days: [String])
}

// MARK: - ScheduleConfigurationScreenController
final class ScheduleConfigurationScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let scheduleConfigurationScreenView = ScheduleConfigurationScreenView()
    private var presenter: ScheduleConfigurationScreenPresenter?
    weak var delegate: ScheduleConfigurationDelegate?

    convenience init(delegate: ScheduleConfigurationDelegate?) {
        self.init()
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addSubview(scheduleConfigurationScreenView)
        setupConstraints()
        presenter = ScheduleConfigurationScreenPresenter(viewController: self)
        presenter?.selectPreviouslyChoosenSchedule(withDays: delegate?.previousSelectedSchedule ?? [])
        scheduleConfigurationScreenView.delegate = self
        scheduleConfigurationScreenView.daysTableView.dataSource = self
        scheduleConfigurationScreenView.daysTableView.delegate = self
    }
}

// MARK: - Helpers
extension ScheduleConfigurationScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scheduleConfigurationScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleConfigurationScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            scheduleConfigurationScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleConfigurationScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ScheduleConfigurationScreenController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.giveNumberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ScheduleConfigurationScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - ScheduleConfigurationScreenViewDelegate
extension ScheduleConfigurationScreenController: ScheduleConfigurationScreenViewDelegate {
    func applySchedule() {
        delegate?.updateSchedule(withDays: presenter?.giveSelectedDays() ?? [])
        dismiss(animated: true)
    }
}
