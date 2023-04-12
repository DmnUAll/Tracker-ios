extension Int {
    func days() -> String {
        if self % 100 / 10 == 1 {
            return "DAYS".localized
        }
        switch self % 10 {
        case 1:
            return "DAY".localized
        case 2...4:
            return "DAYS_LANGUAGE_SENSITIVE".localized
        default:
            return "DAYS".localized
        }
    }
}
