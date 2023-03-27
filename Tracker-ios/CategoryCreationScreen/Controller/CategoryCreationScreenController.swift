import UIKit

// MARK: - CategoryCreationScreenController
final class CategoryCreationScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let categoryCreationScreenView = CategoryCreationScreenView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addSubview(categoryCreationScreenView)
        setupConstraints()
        categoryCreationScreenView.delegate = self
        categoryCreationScreenView.categoryNameTextField.delegate = self
    }
}

// MARK: - Helpers
extension CategoryCreationScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryCreationScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCreationScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            categoryCreationScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCreationScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension CategoryCreationScreenController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count >= 18 {
            categoryCreationScreenView.errorLabel.isHidden = false
        } else {
            categoryCreationScreenView.errorLabel.isHidden = true
        }
        return updatedText.count <= 18
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        categoryCreationScreenView.errorLabel.isHidden = true
        return true
    }
}

// MARK: - CategoryCreationScreenViewDelegate
extension CategoryCreationScreenController: CategoryCreationScreenViewDelegate {
    func saveNewCategory() {
        print(#function)
    }
}
