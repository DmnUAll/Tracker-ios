import UIKit

// MARK: - HabitCreationScreenViewDelegate protocol
protocol HabitCreationScreenViewDelegate: AnyObject {
    func createTracker()
    func cancelCreation()
}

// MARK: - HabitCreationScreenView
final class HabitCreationScreenView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: HabitCreationScreenViewDelegate?

    private let titleLabel = UICreator.shared.makeLabel(text: "Новая привычка",
                                                        font: UIFont.appFont(.medium, withSize: 16))

    private let scrollView: UIScrollView = {
        let scrollView = UICreator.shared.makeScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: 820)
        scrollView.isPagingEnabled = false
        scrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return scrollView
    }()

    let stackView = UICreator.shared.makeStackView()

    let trackerNameTextField: UITextField = {
        let textField = UICreator.shared.makeTextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .ypGrayField.withAlphaComponent(0.3)
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    let errorLabel: UILabel = {
       let label = UICreator.shared.makeLabel(text: "Ограничение 38 символов",
                                              font: UIFont.appFont(.regular, withSize: 17),
                                              color: .ypRedLight)
        label.isHidden = true
        return label
    }()

    let optionsTableView: UITableView = {
        let tableView = UICreator.shared.makeTableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: K.CollectionElementNames.categoryCell)
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: K.CollectionElementNames.scheduleCell)
        return tableView
    }()

    private let emojiTitleLabel = UICreator.shared.makeLabel(text: "Emoji", font: UIFont.appFont(.bold, withSize: 19))

    let emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCell.self,
                                forCellWithReuseIdentifier: K.CollectionElementNames.emojiCell)
        collectionView.allowsMultipleSelection = false
        collectionView.tag = 1
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let colorTitleLabel = UICreator.shared.makeLabel(text: "Цвет", font: UIFont.appFont(.bold, withSize: 19))

    let colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ColorCell.self,
                                forCellWithReuseIdentifier: K.CollectionElementNames.colorCell)
        collectionView.allowsMultipleSelection = false
        collectionView.tag = 2
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let buttonsStackView = UICreator.shared.makeStackView(withAxis: .horizontal,
                                                                  distribution: .fillEqually,
                                                                  andSpacing: 8)

    private let cancelButton: UIButton = {
        let button = UICreator.shared.makeButton(withTitle: "Отмена",
                                                 fontColor: .ypRedLight,
                                                 backgroundColor: .ypWhite,
                                                 action: #selector(cancelButtonTapped))
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRedLight.cgColor
        return button
    }()

    let createButton: UIButton = {
        let button = UICreator.shared.makeButton(withTitle: "Создать",
                                                 backgroundColor: .ypGray,
                                                 action: #selector(createButtonTapped))
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
//
// MARK: - Helpers
extension HabitCreationScreenView {

    @objc private func cancelButtonTapped() {
        delegate?.cancelCreation()
    }

    @objc private func createButtonTapped() {
        delegate?.createTracker()
    }

    private func setupAutolayout() {
        toAutolayout()
        scrollView.toAutolayout()
        titleLabel.toAutolayout()
        stackView.toAutolayout()
        trackerNameTextField.toAutolayout()
        errorLabel.toAutolayout()
        optionsTableView.toAutolayout()
        buttonsStackView.toAutolayout()
        emojiTitleLabel.toAutolayout()
        emojiCollectionView.toAutolayout()
        colorTitleLabel.toAutolayout()
        colorCollectionView.toAutolayout()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        stackView.addArrangedSubview(trackerNameTextField)
        stackView.addArrangedSubview(errorLabel)
        scrollView.addSubview(stackView)
        scrollView.addSubview(optionsTableView)
        scrollView.addSubview(emojiTitleLabel)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorTitleLabel)
        scrollView.addSubview(colorCollectionView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        scrollView.addSubview(buttonsStackView)
        addSubview(scrollView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            optionsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            optionsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            optionsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            optionsTableView.heightAnchor.constraint(equalToConstant: 150),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            emojiTitleLabel.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emojiCollectionView.topAnchor.constraint(equalTo: emojiTitleLabel.bottomAnchor, constant: 32),
            emojiCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 156),
            colorTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            colorTitleLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 32),
            colorCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            colorCollectionView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 32),
            colorCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 156),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
