//
//  TrackersScreenViewModel.swift
//  Tracker-ios
//
//  Created by Илья Валито on 22.04.2023.
//

import UIKit

// MARK: - TrackersScreenViewModel
final class TrackersScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable
    private(set) var needToHideCollection: Bool = false

    @Observable
    private(set) var needToReloadCollection: Bool = false

    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    private let analyticsService = AnalyticsService()
    private var categories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private var currentSearchText: String = ""
    private var havePinnedCategory: Bool {
        categories.contains(where: { $0.name == "PINNED".localized })
    }
    private var currentlyEditingIndex: IndexPath?

    init() {
        completedTrackers = Set(trackerRecordStore.trackers)
        updateDataForUI()
    }

    deinit {
        analyticsService.report(event: K.AnalyticEventNames.close, params: ["screen": K.AnalyticScreenNames.trackers,
                                                                           "item": K.AnalyticItemNames.none])
    }
}

// MARK: - Helpers
extension TrackersScreenViewModel {

    func checkForData() {
        if categories.isEmpty {
            needToHideCollection = true
        } else {
            needToHideCollection = false
        }
    }

    func giveNumberOfCategories() -> Int {
        categories.count
    }

    func giveNumberOfTrackersForCategory(atIndex index: Int) -> Int {
        categories[index].trackers.count
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
        cell.counterLabel.text = timesCompleted.localized
        cell.taskIcon.text = tracker.emoji
        cell.taskName.text = tracker.name
        cell.delegate = self
        if tracker.isPinned {
            cell.pinIcon.isHidden = false
        } else {
            cell.pinIcon.isHidden = true
        }
        return cell
    }

    func configureViewController(forSelectedItemAt indexPath: IndexPath) -> UIViewController {
        currentlyEditingIndex = indexPath
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let count = completedTrackers.filter({ $0.id == tracker.id}).count
        let viewController = HabitCreationScreenController(trackerToEdit: tracker, counter: count)
        return viewController
    }

    func didEnter(_ text: String?) {
        if let text {
            currentSearchText = text
        } else {
            currentSearchText = ""
        }
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
            searchTracks()
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
        searchTracks()
    }

    func deleteTracker(with indexPath: IndexPath) {
        let category = categories[indexPath.section]
        var trackersList = category.trackers
        trackersList.remove(at: indexPath.row)
        if let existingCategory = trackerCategoryStore.checkForExistingCategory(named: category.name) {
            trackerCategoryStore.updateExistingCategory(existingCategory, with: TrackerCategory(name: category.name,
                                                                                                trackers: trackersList))
        }
        updateDataForUI()
    }

    func pinTracker(with indexPath: IndexPath) {
        var tracker = categories[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = true
        deleteTracker(with: indexPath)
        addNewTracker(TrackerCategory(name: "PINNED".localized, trackers: [tracker]))
    }

    func unpinTracker(with indexPath: IndexPath) {
        var tracker = categories[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = false
        deleteTracker(with: indexPath)
        addNewTracker(TrackerCategory(name: tracker.categoryName, trackers: [tracker]))
    }

    func updateTracker(_ trackerCategory: TrackerCategory, counter: Int) {
        guard let tracker = trackerCategory.trackers.first,
              let index = currentlyEditingIndex else { return }
        if tracker.isPinned {
            deleteTracker(with: index)
            addNewTracker(TrackerCategory(name: "PINNED".localized, trackers: [tracker]))
        } else {
            deleteTracker(with: index)
            addNewTracker(TrackerCategory(name: tracker.categoryName, trackers: [tracker]))
        }
        let oldCount = completedTrackers.filter({ $0.id == tracker.id}).count
        if oldCount > counter {
            for _ in 1...(oldCount - counter) {
                if let element = completedTrackers.first(where: { $0.id == tracker.id }) {
                    completedTrackers.remove(element)
                    trackerRecordStore.deleteTracker(element)
                }
            }
        } else if oldCount < counter {
            for _ in 1...(counter - oldCount) {
                let newRecord = TrackerRecord(id: tracker.id, date: Date.randomDateForCounter)
                completedTrackers.insert(newRecord)
                trackerRecordStore.addNewRecord(newRecord)
            }
        }
    }

    func searchTracks() {
        categories = []
        if currentSearchText == "" {
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
                    $0.name.contains(currentSearchText) &&
                    $0.schedule.contains(WeekDay.giveCurrentWeekDay(forDate: currentDate))
                }
                if filteredCategory.count > 0 {
                    categories.append(TrackerCategory(name: category.name, trackers: filteredCategory))
                }
            }
        }
        if let pinnedCategoryIndex = categories.firstIndex(where: { $0.name == "PINNED".localized }) {
            let pinnedCategory = categories.remove(at: pinnedCategoryIndex)
            categories.insert(pinnedCategory, at: 0)
        }
        if categories.count == 0 {
            needToHideCollection = true
        } else {
            needToHideCollection = false
        }
        needToReloadCollection = true
    }

    func updateDataForUI() {
        allCategories = trackerCategoryStore.categories
        if havePinnedCategory,
           allCategories[0].trackers.isEmpty {
            allCategories.remove(at: 0)
        }
        searchTracks()
        needToReloadCollection = true
    }

    func updateCurrentDate(to date: Date) {
        currentDate = date
    }

    func havePinned() -> Bool {
        havePinnedCategory
    }
}

// MARK: - TrackerCellDelegate
extension TrackersScreenViewModel: TrackerCellDelegate {
    func proceedTask(forID trackerID: UUID) {
        analyticsService.report(event: K.AnalyticEventNames.click, params: ["screen": K.AnalyticScreenNames.trackers,
                                                                           "item": K.AnalyticItemNames.completeTrack])
        let proceededTask = TrackerRecord(id: trackerID, date: currentDate.dateString)
        if completedTrackers.contains(proceededTask) {
            completedTrackers.remove(proceededTask)
            trackerRecordStore.deleteTracker(proceededTask)
        } else {
            completedTrackers.insert(proceededTask)
            trackerRecordStore.addNewRecord(proceededTask)
        }
        needToReloadCollection = true
    }
}
