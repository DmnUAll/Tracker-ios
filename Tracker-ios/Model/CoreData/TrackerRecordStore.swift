import UIKit
import CoreData

// MARK: - TrackerRecordStoreError
enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidTrackerRecordDate
    case decodingErrorInvalidUUID
}

// MARK: - TrackerRecordStoreDelegate
protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryStoreUpdate)
}

// MARK: - TrackerRecordStore
final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCD>!
    weak var delegate: TrackerCategoryStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    var trackers: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.getRecord(from: $0) })
        else { return [] }
        return categories
    }

    convenience override init() {
        let context = CoreDataManager.context
        // swiftlint:disable:next force_try
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = TrackerRecordCD.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCD.date, ascending: true)
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

    func addNewRecord(_ trackerRecord: TrackerRecord) {
        let trackerRecordCD = TrackerRecordCD(context: context)
        updateExistingRecord(trackerRecordCD, with: trackerRecord)
    }

    func updateExistingRecord(_ trackerRecordCD: TrackerRecordCD, with record: TrackerRecord) {
        trackerRecordCD.id = record.id
        trackerRecordCD.date = record.date
        try? context.save()
    }

    func deleteTracker(_ tracker: TrackerRecord) {
        let request = NSFetchRequest<TrackerRecordCD>(entityName: "TrackerRecordCD")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@ and date == %@", tracker.id as CVarArg, tracker.date)
        guard let category = try? context.fetch(request).first else { return }
        context.delete(category)
        try? context.save()
    }

    func getRecord(from trackerRecordCD: TrackerRecordCD) throws -> TrackerRecord {
        guard let trackerRecordDate = trackerRecordCD.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidTrackerRecordDate
        }
        guard let trackerRecordUUID = trackerRecordCD.id else {
            throw TrackerRecordStoreError.decodingErrorInvalidUUID
        }
        return TrackerRecord(id: trackerRecordUUID, date: trackerRecordDate)
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
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
