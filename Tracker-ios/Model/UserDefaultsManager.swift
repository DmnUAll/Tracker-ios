import Foundation

// MARK: - UserDefaultsManager
final class UserDefaultsManager {

    static var shared = UserDefaultsManager()

    private enum Keys: String {
        case onboardingHaveBeenAccepted
    }

    private let userDefaults = UserDefaults.standard

    private(set) var isOnboardAccepted: Bool {
        get {
            loadUserDefaults(for: .onboardingHaveBeenAccepted, as: Bool.self) ?? false
        }
        set {
            saveUserDefaults(value: newValue, at: .onboardingHaveBeenAccepted)
        }
    }

    // MARK: - Data Manipulation Methods
    private func loadUserDefaults<T: Codable>(for key: Keys, as dataType: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue),
              let count = try? JSONDecoder().decode(dataType.self, from: data) else {
            return nil
        }
        return count
    }

    private func saveUserDefaults<T: Codable>(value: T, at key: Keys) {
        guard let data = try? JSONEncoder().encode(value) else {
            print("Unable to save data")
            return
        }
        userDefaults.set(data, forKey: key.rawValue)
    }

    func saveOnboardingState() {
        isOnboardAccepted = true
    }
}
