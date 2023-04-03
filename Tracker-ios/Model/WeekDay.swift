import Foundation

enum WeekDay: String, CaseIterable {
    case monday = "MONDAY"
    case tuesday = "TUESDAY"
    case wednesday = "WEDNESDAY"
    case thursday = "THURSDAY"
    case friday = "FRIDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"
    
    func localizedString() -> String {
           return NSLocalizedString(self.rawValue, comment: "")
       }
}
