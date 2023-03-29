import UIKit

// MARK: - TrackersScreenPresenter
final class TrackersScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: TrackersScreenController?
    private var categories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    private var currentWeekDay: WeekDay {
        switch currentDate.weekDayIndex {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .saturday
        case 7:
            return .sunday
        default:
            return .monday
        }
    }

    init(viewController: TrackersScreenController? = nil) {
        self.viewController = viewController
        // swiftlint:disable line_length
        allCategories.append(TrackerCategory(name: "Test1", trackers: [Tracker(id: UUID(), name: "Test0 Test0 Test0 Test0 Test0 Test0 Test0 Test0 Test0", color: .ypBlue, emoji: "😀", schedule: [.monday, .tuesday]),
                                                                    Tracker(id: UUID(), name: "Test1 Test1", color: .green, emoji: "😍", schedule: [.tuesday, .wednesday])]))
        allCategories.append(TrackerCategory(name: "Test2", trackers: [Tracker(id: UUID(), name: "Test2 Test2", color: .red, emoji: "👻", schedule: [.wednesday, .thursday]),
                                                                    Tracker(id: UUID(), name: "Test3 Test3 Test3 Test3 Test3 Test3", color: .purple, emoji: "😼", schedule: [.thursday, .friday])]))
        allCategories.append(TrackerCategory(name: "Test3", trackers: [Tracker(id: UUID(), name: "Test4 Test4", color: .systemPink, emoji: "💀", schedule: [.friday, .saturday]),
                                                                    Tracker(id: UUID(), name: "Test5 Test5 Test5 Test5 Test5 Test5", color: .gray, emoji: "👎", schedule: [.saturday, .sunday])]))
        allCategories.append(TrackerCategory(name: "Test4", trackers: [Tracker(id: UUID(), name: "Test6 Test6", color: .brown, emoji: "🤠", schedule: [.monday, .saturday]),
                                                                    Tracker(id: UUID(), name: "Test7 Test7 Test7 Test7 Test7 Test7", color: .black, emoji: "🙄", schedule: [.saturday, .monday])]))
        // swiftlint:enable line_length
        searchTracks(named: "")
    }
}

// MARK: - Helpers
extension TrackersScreenPresenter {

    private func checkForData() {
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

    func searchTracks(named searchText: String) {
        categories = []
        if searchText == "" {
            allCategories.forEach { category in
                let filteredCategory = category.trackers.filter { $0.schedule.contains(currentWeekDay) }
                if filteredCategory.count > 0 {
                    categories.append(TrackerCategory(name: category.name, trackers: filteredCategory))
                }
            }
        } else {
            allCategories.forEach { category in
                let filteredCategory = category.trackers.filter {
                    $0.name.contains(searchText) && $0.schedule.contains(currentWeekDay)
                }
                if filteredCategory.count > 0 {
                    categories.append(TrackerCategory(name: category.name, trackers: filteredCategory))
                }
            }
        }
        if categories.count == 0 {
            viewController?.hideCollectionView()
        } else {
            viewController?.showCollectionView()
        }
        viewController?.trackersScreenView.collectionView.reloadData()
    }

    func updateCurrentDate(to date: Date) {
        currentDate = date
    }
}
