import UIKit

// MARK: - TrackersScreenPresenter
final class TrackersScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: TrackersScreenController?
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    private var categories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()

    init(viewController: TrackersScreenController? = nil) {
        self.viewController = viewController
        trackerCategoryStore.delegate = self
        allCategories = trackerCategoryStore.categories
        completedTrackers = Set(trackerRecordStore.trackers)
        searchTracks(named: "")
    }
}

// MARK: - Helpers
extension TrackersScreenPresenter {

    private func checkForData() {
        if categories.isEmpty {
            viewController?.hideCollectionView()
        } else {
            viewController?.showCollectionView()
        }
    }

    func giveNumberOfCategories() -> Int {
        return categories.count
    }

    func giveNumberOfTrackersForCategory(atIndex index: Int) -> Int {
        return categories[index].trackers.count
    }

    func configureSupplementaryElement(ofKind kind: String,
                                       forCollectionView collectionView: UICollectionView,
                                       atIndexPath indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let castedView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: K.CollectionElementNames.trackerHeader,
                for: indexPath
            ) as? HeaderSupplementaryView else {
                return UICollectionReusableView()
            }
            castedView.titleLabel.text = "\(categories[indexPath.section].name)"
            return castedView
        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }

    func configureCell(forCollectionView collectionView: UICollectionView,
                       atIndexPath indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionElementNames.trackerCell,
                                                            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let timesCompleted = completedTrackers.filter({ $0.id == tracker.id }).count
        if !completedTrackers.filter({ $0.id == tracker.id && $0.date == currentDate.dateString }).isEmpty {
            cell.counterButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.counterButton.backgroundColor = tracker.color.withAlphaComponent(0.3)
        } else {
            cell.counterButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.counterButton.backgroundColor = tracker.color
        }
        cell.trackerID = tracker.id
        cell.taskView.backgroundColor = tracker.color
        cell.counterLabel.text = "\(timesCompleted) \(timesCompleted.days())"
        cell.taskIcon.text = tracker.emoji
        cell.taskName.text = tracker.name
        cell.delegate = self
        return cell
    }

    func searchTracks(named searchText: String) {
        categories = []
        if searchText == "" {
            allCategories.forEach { category in
                let filteredCategory = category.trackers.filter {
                    $0.schedule.contains(WeekDay.giveCurrentWeekDay(forDate: currentDate))
                }
                if filteredCategory.count > 0 {
                    categories.append(TrackerCategory(name: category.name, trackers: filteredCategory))
                }
            }
        } else {
            allCategories.forEach { category in
                let filteredCategory = category.trackers.filter {
                    $0.name.contains(searchText) &&
                    $0.schedule.contains(WeekDay.giveCurrentWeekDay(forDate: currentDate))
                }
                if filteredCategory.count > 0 {
                    categories.append(TrackerCategory(name: category.name, trackers: filteredCategory))
                }
            }
        }
        if categories.count == 0 {
            viewController?.hideCollectionView()
        } else {
            viewController?.showCollectionView()
        }
        viewController?.trackersScreenView.collectionView.reloadData()
    }

    func updateCurrentDate(to date: Date) {
        currentDate = date
    }

    func addNewTracker(_ data: TrackerCategory) {
        allCategories = trackerCategoryStore.categories
        var updatedAllCategories = allCategories
        let trackerIndex: Int? = updatedAllCategories.firstIndex { category in
            category.name == data.name
        }
        guard let trackerIndex else {
            updatedAllCategories.append(data)
            allCategories = updatedAllCategories
            trackerCategoryStore.addNewCategory(data)
            searchTracks(named: viewController?.trackersScreenView.searchTextField.text ?? "")
            return
        }
        var trackersList = updatedAllCategories[trackerIndex].trackers
        trackersList.append(contentsOf: data.trackers)
        updatedAllCategories[trackerIndex] = TrackerCategory(name: data.name,
                                                      trackers: trackersList)
        allCategories = updatedAllCategories
        if let existingCategory = trackerCategoryStore.checkForExistingCategory(named: data.name) {
            trackerCategoryStore.updateExistingCategory(existingCategory, with: TrackerCategory(name: data.name,
                                                                                                trackers: trackersList))
        }
        searchTracks(named: viewController?.trackersScreenView.searchTextField.text ?? "")
    }
}

// MARK: - TrackerCellDelegate
extension TrackersScreenPresenter: TrackerCellDelegate {
    func proceedTask(forID trackerID: UUID) {
        let proceededTask = TrackerRecord(id: trackerID, date: currentDate.dateString)
        if completedTrackers.contains(proceededTask) {
            completedTrackers.remove(proceededTask)
            trackerRecordStore.deleteTracker(proceededTask)
        } else {
            completedTrackers.insert(proceededTask)
            trackerRecordStore.addNewRecord(proceededTask)
        }
        viewController?.trackersScreenView.collectionView.reloadData()
    }
}

extension TrackersScreenPresenter: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
    }
}
