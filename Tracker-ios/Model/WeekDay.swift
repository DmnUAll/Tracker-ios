import Foundation

public enum WeekDay: String, CaseIterable {
    case monday = "MONDAY"
    case tuesday = "TUESDAY"
    case wednesday = "WEDNESDAY"
    case thursday = "THURSDAY"
    case friday = "FRIDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"

    static func giveShortWeekDayKey<T1: Any>(for weekDay: T1) -> String? {
        let dayKeys = [
            "MONDAY".localized: "MONDAY_SHORT".localized,
            "TUESDAY".localized: "TUESDAY_SHORT".localized,
            "WEDNESDAY".localized: "WEDNESDAY_SHORT".localized,
            "THURSDAY".localized: "THURSDAY_SHORT".localized,
            "FRIDAY".localized: "FRIDAY_SHORT".localized,
            "SATURDAY".localized: "SATURDAY_SHORT".localized,
            "SUNDAY".localized: "SUNDAY_SHORT".localized
        ]
        if let day = weekDay as? WeekDay {
            return dayKeys[day.localizedString()]
        }
        if let day = weekDay as? String {
            return dayKeys[day]
        }
        return nil
    }

    static func giveWeekDayKey(for weekDay: String) -> WeekDay? {
        let scheduleKeys: [String: WeekDay] = ["MONDAY".localized: .monday,
                                               "TUESDAY".localized: .tuesday,
                                               "WEDNESDAY".localized: .wednesday,
                                               "THURSDAY".localized: .thursday,
                                               "FRIDAY".localized: .friday,
                                               "SATURDAY".localized: .saturday,
                                               "SUNDAY".localized: .sunday
        ]
        return scheduleKeys[weekDay]
    }

    static func giveCurrentWeekDay(forDate date: Date) -> WeekDay {
        var currentWeekDay: WeekDay {
            switch date.weekDayIndex {
            case 1:
                return .sunday
            case 2:
                return .monday
            case 3:
                return .tuesday
            case 4:
                return .wednesday
            case 5:
                return .thursday
            case 6:
                return .friday
            case 7:
                return .saturday
            default:
                return .monday
            }
        }
        return currentWeekDay
    }

    func localizedString() -> String {
           return NSLocalizedString(self.rawValue, comment: "")
    }
}
