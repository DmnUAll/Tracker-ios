import Foundation

private let dateDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = "dd.MM.YY"
    return dateFormatter
}()

extension Date {
    var dateString: String { dateDefaultFormatter.string(from: self) }
    var weekDayIndex: Int { Calendar.current.component(.weekday, from: self) }
}
