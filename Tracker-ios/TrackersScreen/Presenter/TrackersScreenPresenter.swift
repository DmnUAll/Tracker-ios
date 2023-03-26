import UIKit

// MARK: - TrackersScreenPresenter
final class TrackersScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: TrackersScreenController?
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []

    init(viewController: TrackersScreenController? = nil) {
        self.viewController = viewController
        categories.append(TrackerCategory(name: "Test", trackers: [Tracker(id: UUID(), name: "Test Test Test Test Test Test Test Test Test", color: .red, emoji: "😀", schedule: [Date()]),
                                                                   Tracker(id: UUID(), name: "Test Test2", color: .green, emoji: "😍", schedule: [Date()])]))
        categories.append(TrackerCategory(name: "Test2", trackers: [Tracker(id: UUID(), name: "Test Test", color: .red, emoji: "😀", schedule: [Date()]),
                                                                   Tracker(id: UUID(), name: "Test Test2 Test Test2 Test Test2", color: .green, emoji: "😍", schedule: [Date()])]))
        
        checkForData()
    }
}

// MARK: - Helpers
extension TrackersScreenPresenter {

    private func checkForData() {
        print(#function)
        if categories.isEmpty {
            viewController?.hideCollectionView()
        } else {
            viewController?.showCollectionView()
        }
    }

    func giveNumberOfCategories() -> Int {
        return categories.count
    }

    func giveNumberOfTrackersForCategory(atIndex index: Int) -> Int {
        return categories[index].trackers.count
    }

    func configureSupplementaryElement(ofKind kind: String,
                                       forCollectionView collectionView: UICollectionView,
                                       atIndexPath indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let castedView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: K.CollectionElementNames.trackerHeader,
                for: indexPath
            ) as? HeaderSupplementaryView else {
                return UICollectionReusableView()
            }
            castedView.titleLabel.text = "\(categories[indexPath.section].name)"
            return castedView
        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }

    func configureCell(forCollectionView collectionView: UICollectionView,
                       atIndexPath indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionElementNames.trackerCell,
                                                            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        cell.taskView.backgroundColor = tracker.color
        cell.counterButton.backgroundColor = tracker.color
        cell.counterLabel.text = "0 дней"
        cell.taskIcon.text = tracker.emoji
        cell.taskName.text = tracker.name
        return cell
    }
}
