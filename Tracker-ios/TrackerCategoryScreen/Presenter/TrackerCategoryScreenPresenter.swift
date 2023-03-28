import UIKit

// MARK: - TrackerCategoryScreenPresenter
final class TrackerCategoryScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: TrackerCategoryScreenController?

    private var categoryNames: [String] = ["123", "321", "1", "123", "321", "1", "123", "321", "1"]

    init(viewController: TrackerCategoryScreenController? = nil) {
        self.viewController = viewController
        checkForData()
    }
}

// MARK: - Helpers
extension TrackerCategoryScreenPresenter {

    private func checkForData() {
        if categoryNames.isEmpty {
            viewController?.hideTableView()
        } else {
            viewController?.showTableView()
        }
    }

    func giveNumberOfItems() -> Int {
        return categoryNames.count
    }

    func configureCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: K.CollectionElementNames.categorySelectionCell,
                                                    for: indexPath) as? CategorySelectionCell {
            cell.categoryLabel.text = categoryNames[indexPath.row]
            if indexPath.row == categoryNames.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func giveSelectedCategory(forIndexPath indexPath: IndexPath) -> String {
        return categoryNames[indexPath.row]
    }

    func deleteItem(at index: Int) {
        categoryNames.remove(at: index)
    }

    func editItem(at index: Int) {

    }
}
