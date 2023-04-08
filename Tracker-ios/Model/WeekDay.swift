import Foundation

public enum WeekDay: String, CaseIterable {
    case monday = "MONDAY"
    case tuesday = "TUESDAY"
    case wednesday = "WEDNESDAY"
    case thursday = "THURSDAY"
    case friday = "FRIDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"

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
