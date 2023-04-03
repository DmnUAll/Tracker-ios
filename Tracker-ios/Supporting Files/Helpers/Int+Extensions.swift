extension Int {
    func days() -> String {
        if self % 100 / 10 == 1 {
            return "дней"
        }
        switch self % 10 {
        case 1:
            return "день"
        case 2...4:
            return "дня"
        default:
            return "дней"
        }
    }
}
