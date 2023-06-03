import Foundation

private let dateDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    dateFormatter.timeZone = TimeZone(identifier: "GMT")
    return dateFormatter
}()

extension Date {
    var dateString: String { dateDefaultFormatter.string(from: self) }
    var weekDayIndex: Int { Calendar.current.component(.weekday, from: self) }
    static var randomDateForCounter: String {
        let date1 = Date.parse("01.01.1980")
        let date2 = Date.parse("01.01.2007")
        return Date.randomBetween(start: date1, end: date2).dateString
    }

    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

    static func parse(_ string: String) -> Date {
        dateDefaultFormatter.date(from: string) ?? Date()
    }
}
