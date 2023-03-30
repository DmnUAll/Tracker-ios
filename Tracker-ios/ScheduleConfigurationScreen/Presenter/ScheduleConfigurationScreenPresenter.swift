import UIKit

// MARK: - ScheduleConfigurationScreenPresenter
final class ScheduleConfigurationScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: ScheduleConfigurationScreenController?

    private let days: [String] = WeekDay.allCases.map { $0.rawValue }
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
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            if indexPath.row == days.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else if indexPath.row == 0 {
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            cell.backgroundColor = .ypGrayField.withAlphaComponent(0.3)
            let accessory = UICreator.shared.makeSwitch(withTag: indexPath.row)
            accessory.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = accessory
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func giveSelectedDays() -> [String] {
        return selectedDays
    }
}
