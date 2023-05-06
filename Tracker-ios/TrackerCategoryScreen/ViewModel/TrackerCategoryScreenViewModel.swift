import UIKit

// MARK: TrackerCategoryScreenViewModel
final class TrackerCategoryScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable
    private(set) var isDataExist: Bool = false

    @Observable
    private(set) var needToReloadTable: Bool = false

    @Observable
    private(set) var batchUpdates: TrackerCategoryStoreUpdate?

    private let trackerCategoryStore = TrackerCategoryStore.shared
    private var categoryNames: [String] = []
    private var previouslySelectedCategory: String = ""
    private var oldCategoryName: String = ""

    init() {
        trackerCategoryStore.delegate = self
        categoryNames = trackerCategoryStore.categories.map { $0.name }.filter { $0 != "PINNED".localized }
        checkForData()
    }
}

// MARK: Helpers
extension TrackerCategoryScreenViewModel {

    func checkForData() {
        isDataExist = !categoryNames.isEmpty
    }

    func selectPreviouslyChoosenCategory(withName name: String) {
        previouslySelectedCategory = name
    }

    func giveNumberOfItems() -> Int {
        categoryNames = trackerCategoryStore.categories.map { $0.name }.filter { $0 != "PINNED".localized }
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
    }
}

// MARK: CategorySavingDelegate
extension TrackerCategoryScreenViewModel: CategorySavingDelegate {

    var categoryToEdit: String {
        oldCategoryName
    }

    func updateCategory(toName newCategoryName: String) {
        trackerCategoryStore.updateExisitingCategoryName(from: oldCategoryName, to: newCategoryName)
        needToReloadTable = true
        checkForData()
    }

    func categoryEditingWasCanceled() {
        oldCategoryName = ""
    }

    func saveNewCategory(named name: String) {
        if !categoryNames.contains(name) {
            categoryNames.append(name)
            trackerCategoryStore.addNewCategory(TrackerCategory(name: name, trackers: []))
            needToReloadTable = true
            checkForData()
        }
    }
}

// MARK: TrackerCategoryStoreDelegate
extension TrackerCategoryScreenViewModel: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        isDataExist = categoryNames.isEmpty
        batchUpdates = update
    }
}
