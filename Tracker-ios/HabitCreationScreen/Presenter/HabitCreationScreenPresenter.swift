import UIKit

// MARK: - HabitCreationScreeenPresenter
final class HabitCreationScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: HabitCreationScreenController?

    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                          "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                          "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]

    private let colors: [UIColor] = [.tr0, .tr1, .tr2, .tr3, .tr4, .tr5,
                                   .tr6, .tr7, .tr8, .tr9, .tr10, .tr11,
                                   .tr12, .tr13, .tr14, .tr15, .tr16, .tr17]

    private let dayKeys = ["Понедельник": "Пн",
                           "Вторник": "Вт",
                           "Среда": "Ср",
                           "Четверг": "Чт",
                           "Пятница": "Пт",
                           "Суббота": " Сб",
                           "Воскресенье": "Вс"]

    private var selectedCategory: String = ""
    private var selectedDays: [String] = []

    init(viewController: HabitCreationScreenController? = nil) {
        self.viewController = viewController
    }
}

// MARK: - Helpers
extension HabitCreationScreenPresenter {

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

    func configureCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = (tableView.dequeueReusableCell(withIdentifier: K.CollectionElementNames.categoryCell,
                                                  for: indexPath) as? CategoryCell) ?? UITableViewCell()
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

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
}

// MARK: - ScheduleConfigurationDelegate
extension HabitCreationScreenPresenter: ScheduleConfigurationDelegate {
    func updateSchedule(withDays days: [String]) {
        days.forEach { item in
            if let key = dayKeys[item] {
                selectedDays.append(key)
            }
        }
        guard let cell = viewController?.habitCreationScreenView.optionsTableView.cellForRow(
            at: IndexPath(row: 1, section: 0)
        ) as? ScheduleCell else {
            return
        }
        cell.infoLabel.text = String(selectedDays.joined(separator: ", "))
        cell.infoLabel.isHidden = false
    }
}

// MARK: - TrackerCategoryConfigurationDelegate
extension HabitCreationScreenPresenter: TrackerCategoryConfigurationDelegate {
    func updateCategory(withCategory category: String) {
        selectedCategory = category
        guard let cell = viewController?.habitCreationScreenView.optionsTableView.cellForRow(
            at: IndexPath(row: 0, section: 0)
        ) as? CategoryCell else {
            return
        }
        cell.infoLabel.text = selectedCategory
        cell.infoLabel.isHidden = false
    }
}
