import UIKit

// MARK: - HabitCreationScreenView protocol
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
                                        height: 0)
        scrollView.isPagingEnabled = false
        return scrollView
    }()

    private let stackView = UICreator.shared.makeStackView()
    let trackerNameTextField: UITextField = {
        let textField = UICreator.shared.makeTextField()
        textField.placeholder = "Введите название трекера"
        return textField
    }()

    let optionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: K.CollectionElementNames.categoryCell)
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: K.CollectionElementNames.scheduleCell)
        tableView.allowsSelection = false
        return tableView
    }()

    private let emojiTitleLabel = UICreator.shared.makeLabel(text: "Emoji", font: UIFont.appFont(.bold, withSize: 19))

    let emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCell.self,
                                forCellWithReuseIdentifier: K.CollectionElementNames.emojiCell)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()

    private let colorTitleLabel = UICreator.shared.makeLabel(text: "Цвет", font: UIFont.appFont(.bold, withSize: 19))

    let colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ColorCell.self,
                                forCellWithReuseIdentifier: K.CollectionElementNames.colorCell)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()

    private let buttonsStackView = UICreator.shared.makeStackView(withAxis: .horizontal,
                                                                  distribution: .fillEqually,
                                                                  andSpacing: 8)

    private let cancelButton: UIButton = {
        let button = UICreator.shared.makeButton(withTitle: "Отмена",
                                                 fontColor: .ypRedLight,
                                                 backgroundColor: .clear,
                                                 action: #selector(createButtonTapped))
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRedLight.cgColor
        return button
    }()

    private let createButton = UICreator.shared.makeButton(action: #selector(createButtonTapped))

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
        titleLabel.toAutolayout()
        stackView.toAutolayout()
        buttonsStackView.toAutolayout()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        stackView.addArrangedSubview(trackerNameTextField)
        stackView.addArrangedSubview(optionsTableView)
        stackView.addArrangedSubview(emojiTitleLabel)
        stackView.addArrangedSubview(emojiCollectionView)
        stackView.addArrangedSubview(colorTitleLabel)
        stackView.addArrangedSubview(colorCollectionView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        scrollView.addSubview(stackView)
        addSubview(scrollView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 14),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
