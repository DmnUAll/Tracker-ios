import UIKit

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
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
        checkIfCanUnlockCreateeButton()
        return updatedText.count <= 38
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorLabel.isHidden = true
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkIfCanUnlockCreateeButton()
    }
}

// MARK: - UITableViewDataSource
extension HabitCreationScreenController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isNonRegularEvent ? 1: 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HabitCreationScreenController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.updateCurrentlySelectedCell(to: tableView.cellForRow(at: indexPath))
        if indexPath.row == 0 {
            let nextViewController = TrackerCategoryScreenController(delegate: viewModel,
                                                                     viewModel: TrackerCategoryScreenViewModel())
            present(nextViewController, animated: true)
        } else {
            let nextViewController = ScheduleConfigurationScreenController(delegate: viewModel)
            present(nextViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HabitCreationScreenController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.giveNumberOfItems(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        viewModel?.configureCell(forCollectionView: collectionView, atIndexPath: indexPath) ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HabitCreationScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        viewModel?.giveItemSize(forCollectionView: collectionView) ?? CGSize()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        viewModel?.giveLineSpacing(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        viewModel?.giveItemSpacing(forCollectionView: collectionView) ?? 0
    }
}

// MARK: - UICollectionViewDelegate
extension HabitCreationScreenController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
            cell.frameView.isHidden = false
            viewModel?.setPickedEmoji(to: cell.emojiIcon.text ?? "")
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
            cell.frameView.layer.borderWidth = 3
            viewModel?.setPickedColor(to: cell.colorView.backgroundColor)
            decreaseCountButton.backgroundColor = cell.colorView.backgroundColor
            increaseCountButton.backgroundColor = cell.colorView.backgroundColor
        }
        checkIfCanUnlockCreateeButton()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectAllItems(animated: true)
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
            cell.frameView.isHidden = true
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
            cell.frameView.layer.borderWidth = 0
        }
    }
}
