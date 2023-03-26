import UIKit

// MARK: - HabitCreationScreeenPresenter
final class HabitCreationScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: HabitCreationScreenController?

    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                          "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                          "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]

    private let colors: [UIColor] = [.t0, .t1, .t2, .t3, .t4, .t5,
                                   .t6, .t7, .t8, .t9, .t10, .t11,
                                   .t12, .t13, .t14, .t15, .t16, .t17]

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
        5
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
        cell.accessoryType = .disclosureIndicator
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
