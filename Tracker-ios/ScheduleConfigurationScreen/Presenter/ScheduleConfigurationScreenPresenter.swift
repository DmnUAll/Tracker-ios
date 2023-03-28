import UIKit

// MARK: - ScheduleConfigurationScreenPresenter
final class ScheduleConfigurationScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: ScheduleConfigurationScreenController?

    private let days: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private var selectedDays: [String] = []

    init(viewController: ScheduleConfigurationScreenController? = nil) {
        self.viewController = viewController
    }
}

// MARK: - Helpers
extension ScheduleConfigurationScreenPresenter {

    @objc private func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            selectedDays.append(days[sender.tag])
        } else {
            selectedDays.removeAll(where: {$0 == days[sender.tag]})
        }
  }

    func giveNumberOfItems() -> Int {
        return days.count
    }

    func configureCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: K.CollectionElementNames.daySelectionCell,
                                                    for: indexPath) as? DaySelectionCell {
            cell.dayLabel.text = days[indexPath.row]
            if indexPath.row == days.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            }
            cell.backgroundColor = .clear
            let accessory = UICreator.shared.makeSwitch(withTag: indexPath.row)
            accessory.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = accessory
            return cell
        }
        return UITableViewCell()
    }

    func giveSelectedDays() -> [String] {
        return selectedDays
    }
}
