import UIKit
import CoreData

// MARK: - TrackerCategoryStoreError
enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidCategoryName
    case decodingErrorInvalidUUID
}

// MARK: - TrackerCategoryStoreUpdate
struct TrackerCategoryStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

// MARK: - TrackerCategoryStoreDelegate
protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryStoreUpdate)
}

// MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCD>!

    weak var delegate: TrackerCategoryStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    convenience override init() {
        let context = CoreDataManager.context
        // swiftlint:disable:next force_try
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = TrackerCategoryCD.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCD.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }

    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.getCategory(from: $0) })
        else { return [] }
        return categories
    }

    func addNewCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCD = TrackerCategoryCD(context: context)
        updateExistingCategory(trackerCategoryCD, with: trackerCategory)
        try context.save()
    }

    func updateExisitingCategoryName(from oldName: String, to newName: String) {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: "TrackerCategoryCD")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name == \(oldName)")
        guard let category = try? context.fetch(request).first else { return }
        let trackers = category.trackers?.allObjects as? [Tracker] ?? []
        updateExistingCategory(category, with: TrackerCategory(name: newName, trackers: trackers))
        try? context.save()
        print(category, trackers)
    }

    func updateExistingCategory(_ trackerCategoryCD: TrackerCategoryCD, with category: TrackerCategory) {
        trackerCategoryCD.name = category.name
        var trackers: [TrackerCD] = []
        category.trackers.forEach { tracker in
            let trackerCD = TrackerCD(context: context)
            trackerCD.id = tracker.id
            trackerCD.name = tracker.name
            trackerCD.color = tracker.color.hexString()
            trackerCD.emoji = tracker.emoji
            trackerCD.schedule = tracker.schedule.map {$0.rawValue}
            trackers.append(trackerCD)
        }
        trackerCategoryCD.trackers = NSSet(array: trackers)
    }

    func deleteCategory(withName categoryName: String) {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: "TrackerCategoryCD")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name == \(categoryName)")
        guard let category = try? context.fetch(request).first else { return }
        context.delete(category)
        try? context.save()
    }

    func getCategory(from trackerCategoryCD: TrackerCategoryCD) throws -> TrackerCategory {
        guard let categoryName = trackerCategoryCD.name else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryName
        }
        guard let categoryTrackers = trackerCategoryCD.trackers?.allObjects as? [Tracker] else {
            throw TrackerCategoryStoreError.decodingErrorInvalidUUID
        }
        return TrackerCategory(
            name: categoryName,
            trackers: categoryTrackers
        )
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(TrackerCategoryStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
