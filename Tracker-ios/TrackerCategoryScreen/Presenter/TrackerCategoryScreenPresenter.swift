import UIKit

// MARK: - TrackerCategoryScreenPresenter
final class TrackerCategoryScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: TrackerCategoryScreenController?

    private var categoryNames: [String] = ["Test1", "Test2", "Test3", "Test4", "1", "2", "3", "4", "5", "6", "7", "8"]
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
        let cell = CategorySelectionCell()
            let categoryName = categoryNames[indexPath.row]
            cell.categoryLabel.text = categoryName
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            if indexPath.row == categoryNames.count - 1 {
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
            cell.selectionStyle = .none
            return cell
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

// MARK: CategorySavingDelegate
extension TrackerCategoryScreenPresenter: CategorySavingDelegate {
    func saveNewCategory(named name: String) {
        if !categoryNames.contains(name) {
            categoryNames.append(name)
            viewController?.trackerCategoryScreenView.categoriesTableView.reloadData()
        }
    }
}
