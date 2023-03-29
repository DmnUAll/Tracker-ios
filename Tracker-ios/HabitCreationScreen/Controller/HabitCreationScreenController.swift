import UIKit

// MARK: - HabitCreationScreenController
final class HabitCreationScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let habitCreationScreenView = HabitCreationScreenView()
    private var presenter: HabitCreationScreenPresenter?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addSubview(habitCreationScreenView)
        view.addKeyboardHiddingFeature()
        setupConstraints()
        presenter = HabitCreationScreenPresenter(viewController: self)
        habitCreationScreenView.delegate = self
        habitCreationScreenView.trackerNameTextField.delegate = self
        habitCreationScreenView.optionsTableView.dataSource = self
        habitCreationScreenView.optionsTableView.delegate = self
        habitCreationScreenView.emojiCollectionView.dataSource = self
        habitCreationScreenView.emojiCollectionView.delegate = self
        habitCreationScreenView.colorCollectionView.dataSource = self
        habitCreationScreenView.colorCollectionView.delegate = self
    }
}

// MARK: - Helpers
extension HabitCreationScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitCreationScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitCreationScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            habitCreationScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habitCreationScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension HabitCreationScreenController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count >= 38 {
            habitCreationScreenView.errorLabel.isHidden = false
        } else {
            habitCreationScreenView.errorLabel.isHidden = true
        }
        checkIfCanUnlockCreateeButton()
        return updatedText.count <= 38
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        habitCreationScreenView.errorLabel.isHidden = true
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func checkIfCanUnlockCreateeButton() {
        if presenter?.checkIfCanCreateHabit() ?? false {
            habitCreationScreenView.createButton.backgroundColor = .ypBlack
            habitCreationScreenView.createButton.isEnabled = true
        } else {
            habitCreationScreenView.createButton.backgroundColor = .ypGray
            habitCreationScreenView.createButton.isEnabled = false
        }
    }
}

// MARK: - UITableViewDataSource
extension HabitCreationScreenController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HabitCreationScreenController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nextViewController = TrackerCategoryScreenController(delegate: presenter)
            present(nextViewController, animated: true)
        } else {
            let nextViewController = ScheduleConfigurationScreenController(delegate: presenter)
            present(nextViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HabitCreationScreenController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.giveNumberOfItems(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        presenter?.configureCell(forCollectionView: collectionView, atIndexPath: indexPath) ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HabitCreationScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        presenter?.giveItemSize(forCollectionView: collectionView) ?? CGSize()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        presenter?.giveLineSpacing(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        presenter?.giveItemSpacing(forCollectionView: collectionView) ?? 0
    }
}

// MARK: - UICollectionViewDelegate
extension HabitCreationScreenController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
            cell.frameView.isHidden = false
            presenter?.setPickedEmoji(to: cell.emojiIcon.text ?? "")
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
            cell.frameView.layer.borderWidth = 3
            presenter?.setPickedColor(to: cell.colorView.backgroundColor)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkIfCanUnlockCreateeButton()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
            cell.frameView.isHidden = true
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
            cell.frameView.layer.borderWidth = 0
        }
    }
}

// MARK: - HabitCreationScreenViewDelegate
extension HabitCreationScreenController: HabitCreationScreenViewDelegate {
    func createTracker() {
        print(#function)
    }

    func cancelCreation() {
        self.dismiss(animated: true)
    }
}
