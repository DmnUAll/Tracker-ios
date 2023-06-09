import UIKit

// MARK: StatisticsScreenViewModel
final class StatisticsScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable
    private(set) var canShowStatistics: Bool = false

    private let trackerRecordStore = TrackerRecordStore()
}

// MARK: Helpers
extension StatisticsScreenViewModel {

    func checkForData() {
        canShowStatistics = !trackerRecordStore.trackers.isEmpty
    }

    func giveBestPeriod() -> String {
        return "-"
    }

    func giveCompletedTrackersCount() -> String {
        return "\(trackerRecordStore.trackers.count)"
    }

    func giveIdealDaysCount() -> String {
        return "-"
    }

    func giveAverageCount() -> String {
        return "-"
    }
}
