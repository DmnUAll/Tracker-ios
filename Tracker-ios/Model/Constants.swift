import Foundation

// swiftlint:disable:next type_name
struct K {

    struct IconNames {
        static let logoIcon = "YPLogo"
        static let trackerIcon = "TrackerIcon"
        static let statisticsIcon = "StatisticsIcon"
        static let pinIcon = "PinIcon"
    }

    struct ImageNames {
        static let firstOnboardingImage = "OnboardingFirstPage"
        static let secondOnboardingImage = "OnboardingSecondPage"
        static let noDataYet = "NoDataYet"
        static let noDataFound = "NoDataFound"
    }

    struct CollectionElementNames {
        static let trackerHeader = "TrackerHeader"
        static let trackerCell = "TrackerCell"
        static let categoryCell = "CategoryCell"
        static let scheduleCell = "ScheduleCell"
        static let emojiCell = "EmojiCell"
        static let colorCell = "ColorCell"
        static let categorySelectionCell = "CategorySelectionCell"
        static let daySelectionCell = "DaySelectionCell"
    }

    struct EntityNames {
        static let trackerCD = "TrackerCD"
        static let trackerCategoryCD = "TrackerCategoryCD"
        static let trackerRecordCD = "TrackerRecordCD"
    }

    struct Keys {
        static let api = "5cc2d938-f2e7-4fd6-a191-2550609796a2"
    }

    struct AnalyticEventNames {
        static let open = "open"
        static let close = "close"
        static let click = "click"
    }

    struct AnalyticScreenNames {
        static let trackers = "Main"
    }

    struct AnalyticItemNames {
        static let none = ""
        static let addTrack = "add_track"
        static let completeTrack = "track"
        static let filter = "filter"
        static let edit = "edit"
        static let delete = "delete"
    }
}
