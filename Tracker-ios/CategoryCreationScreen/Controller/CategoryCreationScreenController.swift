import UIKit

// MARK: - CategorySavingDelegate protocol
protocol CategorySavingDelegate: AnyObject {
    var categoryToEdit: String { get }
    func updateCategory(toName newCategoryName: String)
    func categoryEditingWasCanceled()
    func saveNewCategory(named name: String)
}

// MARK: - CategoryCreationScreenController
final class CategoryCreationScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let categoryCreationScreenView = CategoryCreationScreenView()
    weak var delegate: CategorySavingDelegate?

    convenience init(delegate: CategorySavingDelegate? = nil) {
        self.init()
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addSubview(categoryCreationScreenView)
        view.addKeyboardHiddingFeature()
        setupConstraints()
        categoryCreationScreenView.delegate = self
        categoryCreationScreenView.categoryNameTextField.delegate = self
        if delegate?.categoryToEdit != "" {
            categoryCreationScreenView.titleLabel.text = "Редактирование категории"
            categoryCreationScreenView.categoryNameTextField.text = delegate?.categoryToEdit ?? ""
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if delegate?.categoryToEdit != "" {
            delegate?.categoryEditingWasCanceled()
        }
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text ?? "").isEmpty {
            categoryCreationScreenView.doneButton.backgroundColor = .ypBlack
            categoryCreationScreenView.doneButton.isEnabled = true
        } else {
            categoryCreationScreenView.doneButton.backgroundColor = .ypGray
            categoryCreationScreenView.doneButton.isEnabled = false
        }
    }
}

// MARK: - CategoryCreationScreenViewDelegate
extension CategoryCreationScreenController: CategoryCreationScreenViewDelegate {
    func transferNewCategory() {
        if delegate?.categoryToEdit != "" {
            delegate?.updateCategory(toName: categoryCreationScreenView.categoryNameTextField.text ?? "")
        }
        delegate?.saveNewCategory(named: categoryCreationScreenView.categoryNameTextField.text ?? "")
        self.dismiss(animated: true)
    }
}
