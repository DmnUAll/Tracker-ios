import UIKit

// MARK: StatisticsScreenViewModel
final class StatisticsScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable
    private(set) var canShowStatistics: Bool = false

    private let trackerRecordStore = TrackerRecordStore()
    private let trackersCategoryStore = TrackerCategoryStore()
}

// MARK: Helpers
extension StatisticsScreenViewModel {

    func checkForData() {
        canShowStatistics = !trackerRecordStore.trackers.isEmpty
    }

    func giveBestPeriod() -> String {
//        let grouped = Dictionary(grouping: trackerRecordStore.trackers,
//                                 by: { $0.id }).mapValues { $0.compactMap { Date.parse($0.date) }.sorted() }
        return "-"
    }

    func giveCompletedTrackersCount() -> String {
        return "\(trackerRecordStore.trackers.count)"
    }

    func giveIdealDaysCount() -> String {
        return "-"
    }

    func giveAverageCount() -> String {
//        var tasksPerWeek = 0
//        trackersCategoryStore.categories.forEach { trackerCategory in
//            trackerCategory.trackers.forEach { tracker in
//                tasksPerWeek += tracker.schedule.count
//            }
//        }
//        return String(format: "%.2f", (Double(tasksPerWeek) / 7.0) * Double(trackerRecordStore.trackers.count))
        return "-"
    }
}
