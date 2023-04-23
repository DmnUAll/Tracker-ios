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
    private var categories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private var currentSearchText: String = ""

    init() {
        completedTrackers = Set(trackerRecordStore.trackers)
        updateDataForUI()
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
        cell.counterLabel.text = "\(timesCompleted) \(timesCompleted.days())"
        cell.taskIcon.text = tracker.emoji
        cell.taskName.text = tracker.name
        cell.delegate = self
        return cell
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
        if categories.count == 0 {
            needToHideCollection = true
        } else {
            needToHideCollection = false
        }
        needToReloadCollection = true
    }

    func updateDataForUI() {
        allCategories = trackerCategoryStore.categories
        searchTracks()
        needToReloadCollection = true
    }

    func updateCurrentDate(to date: Date) {
        currentDate = date
    }
}

// MARK: - TrackerCellDelegate
extension TrackersScreenViewModel: TrackerCellDelegate {
    func proceedTask(forID trackerID: UUID) {
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