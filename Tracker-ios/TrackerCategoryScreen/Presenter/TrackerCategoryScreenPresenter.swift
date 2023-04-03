import UIKit

// MARK: - TrackerCategoryScreenPresenter
final class TrackerCategoryScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: TrackerCategoryScreenController?

    private var categoryNames: [String] = ["Test1", "Test2", "Test3", "Test4"]
    private var previouslySelectedCategory: String = ""
    private var oldCategoryName: String = ""

    init(viewController: TrackerCategoryScreenController? = nil) {
        self.viewController = viewController
        checkForData()
    }
}

// MARK: - Helpers
extension TrackerCategoryScreenPresenter {

    func checkForData() {
        if categoryNames.isEmpty {
            viewController?.hideTableView()
        } else {
            viewController?.showTableView()
        }
    }

    func selectPreviouslyChoosenCategory(withName name: String) {
        previouslySelectedCategory = name
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
        if previouslySelectedCategory != "" {
            if indexPath.row == categoryNames.firstIndex(of: previouslySelectedCategory) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.accessoryType = .checkmark
            }
        }
            return cell
        }
    func giveSelectedCategory(forIndexPath indexPath: IndexPath) -> String {
        return categoryNames[indexPath.row]
    }

    func deleteItem(at index: Int) {
        categoryNames.remove(at: index)
    }

    func editItem(at index: Int) {
        oldCategoryName = categoryNames[index]
        viewController?.present(CategoryCreationScreenController(delegate: self), animated: true)
    }
}

// MARK: CategorySavingDelegate
extension TrackerCategoryScreenPresenter: CategorySavingDelegate {

    var categoryToEdit: String {
        oldCategoryName
    }

    func updateCategory(toName newCategoryName: String) {
        let index = categoryNames.firstIndex(of: oldCategoryName) ?? 0
        categoryNames.remove(at: index)
        categoryNames.insert(newCategoryName, at: index)
        viewController?.trackerCategoryScreenView.categoriesTableView.reloadData()
    }

    func categoryEditingWasCanceled() {
        oldCategoryName = ""
    }

    func saveNewCategory(named name: String) {
        if !categoryNames.contains(name) {
            categoryNames.append(name)
            viewController?.trackerCategoryScreenView.categoriesTableView.reloadData()
            checkForData()
        }
    }
}
