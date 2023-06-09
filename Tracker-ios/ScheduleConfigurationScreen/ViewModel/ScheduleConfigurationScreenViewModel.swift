import UIKit

// MARK: - ScheduleConfigurationScreenViewModel
final class ScheduleConfigurationScreenViewModel {

    // MARK: - Properties and Initializers
    private let days: [String] = WeekDay.allCases.map { $0.localizedString()}
    private var selectedDays: [String] = []
    private var previouslySelectedDays: [String] = []
    private var currentSwitchStates: [Bool] {
        var states: [Bool] = []
        days.forEach { day in
            if previouslySelectedDays.contains(day) {
                states.append(true)
            } else {
                states.append(false)
            }
        }
        return states
    }
}

// MARK: - Helpers
extension ScheduleConfigurationScreenViewModel {

    @objc private func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            selectedDays.append(days[sender.tag])
        } else {
            selectedDays.removeAll(where: {$0 == days[sender.tag]})
        }
  }

    func selectPreviouslyChoosenSchedule(withDays days: [String]) {
        previouslySelectedDays = days
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
            if currentSwitchStates[indexPath.row] {
                accessory.isOn = true
                selectedDays.append(days[indexPath.row])
            }
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
