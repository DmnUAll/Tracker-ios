import UIKit
import CoreData

// MARK: - CoreDataManager
struct CoreDataManager {
    // swiftlint:disable:next force_cast
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
