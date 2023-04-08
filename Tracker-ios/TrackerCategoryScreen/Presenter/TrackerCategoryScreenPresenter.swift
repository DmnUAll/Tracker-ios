import UIKit

// MARK: - TrackerCategoryScreenPresenter
final class TrackerCategoryScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: TrackerCategoryScreenController?
    private let trackerCategoryStore = TrackerCategoryStore()
    private var categoryNames: [String] = []
    private var previouslySelectedCategory: String = ""
    private var oldCategoryName: String = ""

    init(viewController: TrackerCategoryScreenController? = nil) {
        self.viewController = viewController
        trackerCategoryStore.delegate = self
        categoryNames = trackerCategoryStore.categories.map { $0.name }
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
        categoryNames = trackerCategoryStore.categories.map { $0.name }
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
        trackerCategoryStore.deleteCategory(withName: categoryNames[index])
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
        trackerCategoryStore.updateExisitingCategoryName(from: oldCategoryName, to: newCategoryName)
        viewController?.trackerCategoryScreenView.categoriesTableView.reloadData()
    }

    func categoryEditingWasCanceled() {
        oldCategoryName = ""
    }

    func saveNewCategory(named name: String) {
        if !categoryNames.contains(name) {
            categoryNames.append(name)
            try? trackerCategoryStore.addNewCategory(TrackerCategory(name: name, trackers: []))
            viewController?.trackerCategoryScreenView.categoriesTableView.reloadData()
            checkForData()
        }
    }
}

// MARK: TrackerCategoryStoreDelegate
extension TrackerCategoryScreenPresenter: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        guard let tableView = viewController?.trackerCategoryScreenView.categoriesTableView else { return }
        tableView.performBatchUpdates {
            let insertedIndexPaths = update.insertedIndexes.map { IndexPath(item: $0, section: 0) }
            let deletedIndexPaths = update.deletedIndexes.map { IndexPath(item: $0, section: 0) }
            tableView.insertRows(at: insertedIndexPaths, with: .automatic)
            tableView.deleteRows(at: deletedIndexPaths, with: .fade)
        }
    }
}
