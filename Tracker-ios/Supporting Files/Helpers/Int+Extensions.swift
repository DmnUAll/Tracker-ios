import Foundation

extension Int {

    var localized: String {
        return String.localizedStringWithFormat(
            NSLocalizedString("daysStreak", comment: ""),
            self
        )
    }
}
