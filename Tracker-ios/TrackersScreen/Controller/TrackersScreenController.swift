import UIKit

// MARK: - TrackersScreenController
final class TrackersScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let trackersScreenView = TrackersScreenView()
    private var presenter: TrackersScreenPresenter?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.addSubview(trackersScreenView)
        view.backgroundColor = .ypWhite
        view.addKeyboardHiddingFeature()
        setupConstraints()
        hideCollectionView()
        presenter = TrackersScreenPresenter(viewController: self)
        (navigationController as? NavigationController)?.dateReceiverDelegate = self
        trackersScreenView.delegate = self
        trackersScreenView.searchTextField.delegate = self
        trackersScreenView.collectionView.dataSource = self
        trackersScreenView.collectionView.delegate = self
    }
}

// MARK: - Helpers
extension TrackersScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackersScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            trackersScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func hideCollectionView() {
        trackersScreenView.noDataImage.isHidden = false
        trackersScreenView.noDataLabel.isHidden = false
        trackersScreenView.collectionView.isHidden = true
        trackersScreenView.filterButton.isHidden = true
    }

    func showCollectionView() {
        trackersScreenView.noDataImage.isHidden = true
        trackersScreenView.noDataLabel.isHidden = true
        trackersScreenView.collectionView.isHidden = false
        trackersScreenView.filterButton.isHidden = false
    }

    func addData(_ data: TrackerCategory) {
        presenter?.addNewTracker(data)
    }

    func updateCollectionView() {
        presenter?.updateDataForUI()
        trackersScreenView.collectionView.reloadData()
    }
}

// MARK: TrackersScreenViewDelegate
extension TrackersScreenController: TrackersScreenViewDelegate {
    func cancelSearch() {
        trackersScreenView.searchTextField.text = ""
        trackersScreenView.cancelButton.isHidden = true
        presenter?.searchTracks(named: "")
        becomeFirstResponder()
    }

    func showFilters() {
        print(#function)
    }
}

// MARK: - UISearchTextFieldDelegate
extension TrackersScreenController: UISearchTextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count > 0 {
            trackersScreenView.cancelButton.isHidden = false
        } else {
            trackersScreenView.cancelButton.isHidden = true
        }
        presenter?.searchTracks(named: updatedText)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - UICollectionDataSource
extension TrackersScreenController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.giveNumberOfCategories() ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.giveNumberOfTrackersForCategory(atIndex: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        presenter?.configureCell(forCollectionView: collectionView, atIndexPath: indexPath) ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - 40
        let cellWidth =  availableWidth / CGFloat(2)
        return CGSize(width: cellWidth,
                      height: cellWidth * 2 / 2.5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 16, bottom: 32, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersScreenController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        presenter?.configureSupplementaryElement(ofKind: kind,
                                                 forCollectionView: collectionView,
                                                 atIndexPath: indexPath) ?? UICollectionReusableView()
    }
}

// MARK: - DateReceiveDelegate
extension TrackersScreenController: DateReceiveDelegate {
    func applyDate(_ date: Date) {
        presenter?.updateCurrentDate(to: date)
        presenter?.searchTracks(named: trackersScreenView.searchTextField.text ?? "")
    }
}
