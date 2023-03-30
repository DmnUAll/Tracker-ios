import UIKit

// MARK: - CategoryCreationScreenViewDelegate protocol
protocol CategoryCreationScreenViewDelegate: AnyObject {
    func transferNewCategory()
}

// MARK: - CategoryCreationScreenView
final class CategoryCreationScreenView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: CategoryCreationScreenViewDelegate?

    let titleLabel = UICreator.shared.makeLabel(text: "Новая категория",
                                                        font: UIFont.appFont(.medium, withSize: 16))
    let stackView = UICreator.shared.makeStackView()

    let categoryNameTextField: UITextField = {
        let textField = UICreator.shared.makeTextField()
        textField.placeholder = "Введите название категории"
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .ypGrayField.withAlphaComponent(0.3)
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    let errorLabel: UILabel = {
       let label = UICreator.shared.makeLabel(text: "Ограничение 18 символов",
                                              font: UIFont.appFont(.regular, withSize: 17),
                                              color: .ypRedLight)
        label.isHidden = true
        return label
    }()

    let doneButton: UIButton = {
        let button = UICreator.shared.makeButton(withTitle: "Готово",
                                                 backgroundColor: .ypGray,
                                                 action: #selector(doneButtonTapped))
        button.isEnabled = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension CategoryCreationScreenView {

    @objc private func doneButtonTapped() {
        delegate?.transferNewCategory()
    }

    private func setupAutolayout() {
        toAutolayout()
        titleLabel.toAutolayout()
        stackView.toAutolayout()
        categoryNameTextField.toAutolayout()
        errorLabel.toAutolayout()
        doneButton.toAutolayout()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        stackView.addArrangedSubview(categoryNameTextField)
        stackView.addArrangedSubview(errorLabel)
        addSubview(stackView)
        addSubview(doneButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
