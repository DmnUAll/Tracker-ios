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
    weak var delegate: CategorySavingDelegate?
    private let analyticsService = AnalyticsService()

    private let titleLabel = UICreator.shared.makeLabel(text: "NEW_CATEGORY".localized,
                                                        font: UIFont.appFont(.medium, withSize: 16))
    private let stackView = UICreator.shared.makeStackView()

    private let categoryNameTextField: UITextField = {
        let textField = UICreator.shared.makeTextField()
        textField.placeholder = "ENTER_CATEGORY_NAME".localized
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .ypGrayField.withAlphaComponent(0.3)
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    private let errorLabel: UILabel = {
       let label = UICreator.shared.makeLabel(text: "SYMBOLS_LIMIT_18".localized,
                                              font: UIFont.appFont(.regular, withSize: 17),
                                              color: .ypRedLight)
        label.isHidden = true
        return label
    }()

    private let doneButton: UIButton = {
        let button = UICreator.shared.makeButton(withTitle: "DONE".localized,
                                                 backgroundColor: .ypGray,
                                                 action: #selector(doneButtonTapped))
        button.isEnabled = false
        return button
    }()

    convenience init(delegate: CategorySavingDelegate? = nil) {
        self.init()
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addKeyboardHiddingFeature()
        setupAutolayout()
        addSubviews()
        setupConstraints()
        categoryNameTextField.delegate = self
        if delegate?.categoryToEdit != "" {
            titleLabel.text = "CATEGORY_EDITING".localized
            categoryNameTextField.text = delegate?.categoryToEdit ?? ""
        }
        analyticsService.report(event: K.AnalyticEventNames.open,
                                params: ["screen": K.AnalyticScreenNames.categoryCreation,
                                         "item": K.AnalyticItemNames.none])
    }

    override func viewWillDisappear(_ animated: Bool) {
        if delegate?.categoryToEdit != "" {
            delegate?.categoryEditingWasCanceled()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: K.AnalyticEventNames.close,
                                params: ["screen": K.AnalyticScreenNames.categoryCreation,
                                         "item": K.AnalyticItemNames.none])
    }
}

// MARK: - Helpers
extension CategoryCreationScreenController {

    @objc private func doneButtonTapped() {
        analyticsService.report(event: K.AnalyticEventNames.click,
                                params: ["screen": K.AnalyticScreenNames.categoryCreation,
                                         "item": K.AnalyticItemNames.confirmCategoryCreation])
        let categoryName = categoryNameTextField.text ?? ""
        if delegate?.categoryToEdit != "" {
            delegate?.updateCategory(toName: categoryName)
        } else {
            delegate?.saveNewCategory(named: categoryName)
        }
        self.dismiss(animated: true)    }

    private func setupAutolayout() {
        titleLabel.toAutolayout()
        stackView.toAutolayout()
        categoryNameTextField.toAutolayout()
        errorLabel.toAutolayout()
        doneButton.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        stackView.addArrangedSubview(categoryNameTextField)
        stackView.addArrangedSubview(errorLabel)
        view.addSubview(stackView)
        view.addSubview(doneButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
        return updatedText.count <= 18
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
        if !(textField.text ?? "").isEmpty {
            doneButton.backgroundColor = .ypBlack
            doneButton.isEnabled = true
        } else {
            doneButton.backgroundColor = .ypGray
            doneButton.isEnabled = false
        }
    }
}
