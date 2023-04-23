import UIKit

// MARK: - HabitCreationScreenController
final class HabitCreationScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private var viewModel: HabitCreationScreenViewModel?
    private var isNonRegularEvent: Bool = false

    private let titleLabel = UICreator.shared.makeLabel(text: "NEW_HABIT".localized,
                                                        font: UIFont.appFont(.medium, withSize: 16))

    private let scrollView: UIScrollView = {
        let scrollView = UICreator.shared.makeScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: 820)
        scrollView.isPagingEnabled = false
        scrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return scrollView
    }()

    private let stackView = UICreator.shared.makeStackView()

    private let trackerNameTextField: UITextField = {
        let textField = UICreator.shared.makeTextField(withTarget: #selector(textFieldDidChange))
        textField.placeholder = "ENTER_TRACKER_NAME".localized
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .ypGrayField.withAlphaComponent(0.3)
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    private let errorLabel: UILabel = {
       let label = UICreator.shared.makeLabel(text: "SYMBOLS_LIMIT_38".localized,
                                              font: UIFont.appFont(.regular, withSize: 17),
                                              color: .ypRedLight)
        label.isHidden = true
        return label
    }()

    private let optionsTableView: UITableView = {
        let tableView = UICreator.shared.makeTableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: K.CollectionElementNames.categoryCell)
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: K.CollectionElementNames.scheduleCell)
        return tableView
    }()

    private let emojiTitleLabel = UICreator.shared.makeLabel(text: "Emoji", font: UIFont.appFont(.bold, withSize: 19))

    private let emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCell.self,
                                forCellWithReuseIdentifier: K.CollectionElementNames.emojiCell)
        collectionView.allowsMultipleSelection = false
        collectionView.tag = 1
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let colorTitleLabel = UICreator.shared.makeLabel(text: "COLOR".localized,
                                                             font: UIFont.appFont(.bold, withSize: 19))

    private let colorCollectionView: UICollectionView = {
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
        let button = UICreator.shared.makeButton(withTitle: "CANCEL".localized,
                                                 fontColor: .ypRedLight,
                                                 backgroundColor: .ypWhite,
                                                 action: #selector(cancelButtonTapped))
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRedLight.cgColor
        return button
    }()

    private let createButton: UIButton = {
        let button = UICreator.shared.makeButton(withTitle: "CREATE".localized,
                                                 backgroundColor: .ypGray,
                                                 action: #selector(createButtonTapped))
        button.isEnabled = false
        return button
    }()

    convenience init(isNonRegularEvent: Bool) {
        self.init()
        self.isNonRegularEvent = isNonRegularEvent
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addKeyboardHiddingFeature()
        setupAutolayout()
        addSubviews()
        setupConstraints()
        viewModel = HabitCreationScreenViewModel()
        bind()
        trackerNameTextField.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        if isNonRegularEvent {
            titleLabel.text = "NEW_NON_REGULAR_EVENT".localized
            optionsTableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        } else {
            optionsTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
    }
}

// MARK: - Helpers
extension HabitCreationScreenController {

    @objc private func textFieldDidChange() {
        viewModel?.didEnter(trackerNameTextField.text)
    }

    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func createButtonTapped() {
        if let topController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let destinationViewController = topController.children.first?.children.first as? TrackersScreenController
            if let viewModel = viewModel {
                destinationViewController?.addData(viewModel.createNewTracker())
            }
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }

    private func setupAutolayout() {
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
        view.addSubview(titleLabel)
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
        view.addSubview(scrollView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            emojiTitleLabel.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emojiCollectionView.topAnchor.constraint(equalTo: emojiTitleLabel.bottomAnchor, constant: 32),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 156),
            colorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            colorTitleLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 32),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorCollectionView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 32),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 156),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$canUnlockCreateButton.bind { [weak self] _ in
            guard let self else { return }
            self.checkIfCanUnlockCreateeButton()
        }
    }

    func checkIfCanUnlockCreateeButton() {
        if viewModel?.checkIfCanCreateHabit() ?? false {
            createButton.backgroundColor = .ypBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .ypGray
            createButton.isEnabled = false
        }
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
        }
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
