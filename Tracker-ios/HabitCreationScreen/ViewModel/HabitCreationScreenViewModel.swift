import UIKit

// MARK: - HabitCreationScreenViewModel
final class HabitCreationScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable
    private(set) var canUnlockCreateButton: Bool = false

    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                          "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                          "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]

    private let colors: [UIColor] = [.tr0, .tr1, .tr2, .tr3, .tr4, .tr5,
                                   .tr6, .tr7, .tr8, .tr9, .tr10, .tr11,
                                   .tr12, .tr13, .tr14, .tr15, .tr16, .tr17]

    private var trackerName: String = ""
    private var selectedCategory: String = ""
    private var selectedDaysRaw: [String] = []
    private var selectedDays: [String] = []
    private var selectedEmoji: String = ""
    private var selectedColor: UIColor?
    private var selectedSchedule: [WeekDay] = []
    private var isNonRegularEvent: Bool = false
    private var selectedCell: UITableViewCell?

    convenience init(isNonRegularEvent: Bool) {
        self.init()
        self.isNonRegularEvent = isNonRegularEvent
        if isNonRegularEvent {
            let day = WeekDay.giveCurrentWeekDay(forDate: Date())
            if let dayKey = WeekDay.giveShortWeekDayKey(for: day) {
                selectedDays.append(dayKey)
            }
        }
    }
}

// MARK: - Helpers
extension HabitCreationScreenViewModel {

    func didEnter(_ text: String?) {
        if let text {
            trackerName = text
        } else {
            trackerName = ""
        }
    }

    func updateCurrentlySelectedCell(to cell: UITableViewCell?) {
        selectedCell = cell
    }

    func giveNumberOfItems(forCollectionView collectionView: UICollectionView) -> Int {
        if collectionView.tag == 1 {
            return emojis.count
        } else {
            return colors.count
        }
    }

    func giveItemSize(forCollectionView collectionView: UICollectionView) -> CGSize {
        return CGSize(width: 52, height: 52)
    }

    func giveLineSpacing(forCollectionView collectionView: UICollectionView) -> CGFloat {
        0
    }

    func giveItemSpacing(forCollectionView collectionView: UICollectionView) -> CGFloat {
        (UIScreen.main.bounds.width / 86)
    }

    func setPickedEmoji(to emoji: String) {
        selectedEmoji = emoji
    }

    func setPickedColor(to color: UIColor?) {
        selectedColor = color
    }

    func configureCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = (tableView.dequeueReusableCell(withIdentifier: K.CollectionElementNames.categoryCell,
                                                  for: indexPath) as? CategoryCell) ?? UITableViewCell()
            if isNonRegularEvent {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            }
        } else {
            cell = (tableView.dequeueReusableCell(withIdentifier: K.CollectionElementNames.scheduleCell,
                                                  for: indexPath) as? ScheduleCell) ?? UITableViewCell()
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        cell.backgroundColor = .clear
        cell.tintColor = .ypGray
        let image = UIImage(systemName: "chevron.right")
        let chevron  = UIImageView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: (image?.size.width) ?? 0,
                                                 height: (image?.size.height) ?? 0))
        chevron.image = image
        cell.accessoryView = chevron
        return cell
    }

    func configureCell(forCollectionView collectionView: UICollectionView,
                       atIndexPath indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionElementNames.emojiCell,
                                                             for: indexPath) as? EmojiCell {
                cell.emojiIcon.text = emojis[indexPath.row]
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionElementNames.colorCell,
                                                             for: indexPath) as? ColorCell {
                cell.frameView.layer.borderColor = colors[indexPath.row].withAlphaComponent(0.3).cgColor
                cell.colorView.backgroundColor = colors[indexPath.row]
                return cell
            }
        }
        return UICollectionViewCell()
    }

    func createNewTracker() -> TrackerCategory {
        let schedule = isNonRegularEvent ? [WeekDay.giveCurrentWeekDay(forDate: Date())] : selectedSchedule
        return TrackerCategory(name: selectedCategory,
                               trackers: [
                                Tracker(id: UUID(),
                                        name: trackerName,
                                        color: selectedColor ?? UIColor(),
                                        emoji: selectedEmoji,
                                        schedule: schedule)
                               ])
    }

    func checkIfCanCreateHabit() -> Bool {
        guard !trackerName.isEmpty,
              !selectedCategory.isEmpty,
              !selectedDays.isEmpty,
              !selectedEmoji.isEmpty,
              selectedColor != nil else {
            return false
        }
        return true
    }
}

// MARK: - TrackerCategoryConfigurationDelegate
extension HabitCreationScreenViewModel: TrackerCategoryConfigurationDelegate {

    var previousSelectedCategory: String {
        selectedCategory
    }

    func updateCategory(withCategory category: String) {
        selectedCategory = category
        guard let cell = selectedCell as? CategoryCell else {
            return
        }
        cell.infoLabel.text = selectedCategory
        cell.infoLabel.isHidden = false
        canUnlockCreateButton = checkIfCanCreateHabit()
    }
}

// MARK: - ScheduleConfigurationDelegate
extension HabitCreationScreenViewModel: ScheduleConfigurationDelegate {

    var previousSelectedSchedule: [String] {
        selectedDaysRaw
    }

    func updateSchedule(withDays days: [String]) {
        selectedDays = []
        selectedDaysRaw = days
        guard let cell = selectedCell as? ScheduleCell else {
            return
        }
        days.forEach { item in
            if let key = WeekDay.giveShortWeekDayKey(for: item) {
                selectedDays.append(key)
            }
            if let key = WeekDay.giveWeekDayKey(for: item) {
                selectedSchedule.append(key)
            }
        }
        if days.count == 7 {
            cell.infoLabel.text = "EVERYDAY".localized
        } else {
            cell.infoLabel.text = String(selectedDays.joined(separator: ", "))
        }
        cell.infoLabel.isHidden = false
        canUnlockCreateButton = checkIfCanCreateHabit()
    }
}
