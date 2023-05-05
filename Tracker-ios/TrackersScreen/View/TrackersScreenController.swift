import UIKit

// MARK: - TrackersScreenController
final class TrackersScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private var viewModel: TrackersScreenViewModel?

    private let uiCreator = UICreator.shared

    private let noDataImage = UICreator.shared.makeImageView(withImage: K.ImageNames.noDataImage)
    private let noDataLabel = UICreator.shared.makeLabel(
        text: "WHAT_TO_MONITOR".localized,
        font: UIFont.appFont(.medium, withSize: 12))

    private let stackView = UICreator.shared.makeStackView(withAxis: .horizontal, andSpacing: 14)
    private let searchTextField = UICreator.shared.makeSearchTextField(withTarget: #selector(textFieldDidChange))
    private let cancelButton: UIButton = {
        let button = UICreator.shared.makeButton(withTitle: "CANCEL".localized,
                                                 font: UIFont.appFont(.regular, withSize: 17),
                                                 backgroundColor: .clear,
                                                 action: #selector(cancelButtonTapped))
        button.setTitleColor(.ypBlue, for: .normal)
        button.isHidden = true
        return button
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerCell.self,
                                forCellWithReuseIdentifier: K.CollectionElementNames.trackerCell)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: K.CollectionElementNames.trackerHeader)
        collectionView.allowsMultipleSelection = false
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 80, right: 0)
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return collectionView
    }()
    private let filterButton = UICreator.shared.makeButton(withTitle: "FILTERS".localized,
                                                   font: UIFont.appFont(.regular, withSize: 17),
                                                   backgroundColor: .ypBlue,
                                                   action: #selector(filterButtonTapped))

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addKeyboardHiddingFeature()
        setupAutolayout()
        addSubviews()
        setupConstraints()
        hideCollectionView()
        viewModel = TrackersScreenViewModel()
        bind()
        viewModel?.checkForData()
        (navigationController as? NavigationController)?.dateReceiverDelegate = self
        searchTextField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - Helpers
extension TrackersScreenController {

    @objc private func cancelButtonTapped() {
        searchTextField.text = ""
        textFieldDidChange()
        cancelButton.isHidden = true
        becomeFirstResponder()
    }

    @objc private func textFieldDidChange() {
        viewModel?.didEnter(searchTextField.text)
        viewModel?.searchTracks()
    }

    @objc private func filterButtonTapped() {
        // TODO: - filters logic needed
        print(#function)
    }

    private func setupAutolayout() {
        noDataImage.toAutolayout()
        noDataLabel.toAutolayout()
        stackView.toAutolayout()
        collectionView.toAutolayout()
        filterButton.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(noDataImage)
        view.addSubview(noDataLabel)
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(cancelButton)
        view.addSubview(stackView)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noDataImage.heightAnchor.constraint(equalToConstant: 80),
            noDataImage.widthAnchor.constraint(equalTo: noDataImage.heightAnchor),
            noDataImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.topAnchor.constraint(equalTo: noDataImage.bottomAnchor, constant: 8),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$needToReloadCollection.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.collectionView.reloadData()
            }
        }
        viewModel.$needToHideCollection.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.hideCollectionView()
            } else {
                self.showCollectionView()
            }
        }
    }

    private func hideCollectionView() {
        noDataImage.isHidden = false
        noDataLabel.isHidden = false
        collectionView.isHidden = true
        filterButton.isHidden = true
    }

    private func showCollectionView() {
        noDataImage.isHidden = true
        noDataLabel.isHidden = true
        collectionView.isHidden = false
        filterButton.isHidden = false
    }

    func addData(_ data: TrackerCategory) {
        viewModel?.addNewTracker(data)
    }

    func updateData(_ trackerCategory: TrackerCategory, counter: Int) {
        viewModel?.updateTracker(trackerCategory, counter: counter)
    }

    func updateCollectionView() {
        viewModel?.updateDataForUI()
    }

    func showDeletionAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "TRACKER_DELETION".localized,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "DELETE".localized,
                                         style: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.deleteTracker(with: indexPath)
            self.collectionView.reloadData()
            self.viewModel?.checkForData()
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
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
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }
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
        viewModel?.giveNumberOfCategories() ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.giveNumberOfTrackersForCategory(atIndex: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        viewModel?.configureCell(forCollectionView: collectionView, atIndexPath: indexPath) ?? UICollectionViewCell()
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
        viewModel?.configureSupplementaryElement(ofKind: kind,
                                                 forCollectionView: collectionView,
                                                 atIndexPath: indexPath) ?? UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let havePinned = viewModel?.havePinned() ?? false
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            var pinAction = UIAction(title: "PIN".localized) { [weak self] _ in
                guard let self else { return }
                self.viewModel?.pinTracker(with: indexPath)
            }
            if havePinned,
               indexPath.section == 0 {
                pinAction = UIAction(title: "UNPIN".localized) { [weak self] _ in
                    guard let self else { return }
                    self.viewModel?.unpinTracker(with: indexPath)
                }
            }

            let editAction = UIAction(title: "EDIT".localized) { [weak self] _ in
                guard let self,
                      let viewController = self.viewModel?.configureViewController(
                        forSelectedItemAt: indexPath) else { return }
                self.present(viewController, animated: true)
            }

            let deleteAction = UIAction(title: "DELETE".localized, attributes: .destructive) { [weak self] _ in
                guard let self else { return }
                self.showDeletionAlert(for: indexPath)
            }
            return UIMenu(children: [pinAction, editAction, deleteAction])
        }
        return configuration
    }
}

// MARK: - DateReceiveDelegate
extension TrackersScreenController: DateReceiveDelegate {
    func applyDate(_ date: Date) {
        viewModel?.updateCurrentDate(to: date)
        viewModel?.searchTracks()
    }
}
