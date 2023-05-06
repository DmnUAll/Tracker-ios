import UIKit

// MARK: - HabitCreationScreenController
final class HabitCreationScreenController: UIViewController {

    // MARK: - Properties and Initializers
    var viewModel: HabitCreationScreenViewModel?
    let analyticsService = AnalyticsService()
    var isNonRegularEvent: Bool = false
    private var trackerToEdit: Tracker?

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
    private let counterStackView = UICreator.shared.makeStackView(withAxis: .horizontal, align: .center, andSpacing: 24)

    let decreaseCountButton: UIButton = {
        let button = UICreator.shared.makeButton(action: #selector(decreaseCountButtonTapped))
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        return button
    }()

    private let counterLabel = UICreator.shared.makeLabel(text: "0", font: UIFont.appFont(.bold, withSize: 32))

    let increaseCountButton: UIButton = {
        let button = UICreator.shared.makeButton(action: #selector(increaseCountButtonTapped))
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        return button
    }()

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

    let errorLabel: UILabel = {
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

    convenience init(trackerToEdit: Tracker, counter: Int) {
        self.init()
        self.trackerToEdit = trackerToEdit
        self.counterLabel.text = "\(counter)"
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addKeyboardHiddingFeature()
        setupAutolayout()
        addSubviews()
        setupConstraints()
        if let trackerToEdit {
            counterStackView.isHidden = false
            viewModel = HabitCreationScreenViewModel(trackerToEdit: trackerToEdit)
        } else {
            counterStackView.isHidden = true
            viewModel = HabitCreationScreenViewModel(isNonRegularEvent: isNonRegularEvent)
        }
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
        analyticsService.report(event: K.AnalyticEventNames.open,
                                params: ["screen": K.AnalyticScreenNames.trackerCreation,
                                         "item": K.AnalyticItemNames.none])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if trackerToEdit != nil {
            updateUIForEditing()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: K.AnalyticEventNames.close,
                                params: ["screen": K.AnalyticScreenNames.trackerCreation,
                                         "item": K.AnalyticItemNames.none])
    }
}

// MARK: - Helpers
extension HabitCreationScreenController {

    @objc private func textFieldDidChange() {
        viewModel?.didEnter(trackerNameTextField.text)
    }

    @objc private func decreaseCountButtonTapped() {
        if let count = Int(counterLabel.text ?? "") {
            counterLabel.text = "\(count == 0 ? 0 : count - 1)"
        }
    }

    @objc private func increaseCountButtonTapped() {
        if let count = Int(counterLabel.text ?? "") {
            counterLabel.text = "\(count + 1)"
        }
    }

    @objc private func cancelButtonTapped() {
        analyticsService.report(event: K.AnalyticEventNames.click,
                                params: ["screen": K.AnalyticScreenNames.trackerCreation,
                                         "item": K.AnalyticItemNames.cancelTrackerCreation])
        self.dismiss(animated: true)
    }

    @objc private func createButtonTapped() {
        analyticsService.report(event: K.AnalyticEventNames.click,
                                params: ["screen": K.AnalyticScreenNames.trackerCreation,
                                         "item": K.AnalyticItemNames.confirmTrackerCreation])
        if let topController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let destinationViewController = topController.children.first?.children.first as? TrackersScreenController
            if let viewModel = viewModel {
                if trackerToEdit == nil {
                    destinationViewController?.addData(viewModel.createNewTracker())
                } else {
                    destinationViewController?.updateData(viewModel.createNewTracker(),
                                                          counter: Int(counterLabel.text ?? "") ?? 0)
                }
            }
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }

    private func setupAutolayout() {
        scrollView.toAutolayout()
        titleLabel.toAutolayout()
        counterStackView.toAutolayout()
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
        counterStackView.addArrangedSubview(decreaseCountButton)
        counterStackView.addArrangedSubview(counterLabel)
        counterStackView.addArrangedSubview(increaseCountButton)
        scrollView.addSubview(counterStackView)
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
        let topInset: CGFloat = trackerToEdit == nil ? -24 : 40
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            decreaseCountButton.heightAnchor.constraint(equalToConstant: 34),
            decreaseCountButton.widthAnchor.constraint(equalTo: decreaseCountButton.heightAnchor, multiplier: 1),
            increaseCountButton.heightAnchor.constraint(equalToConstant: 34),
            increaseCountButton.widthAnchor.constraint(equalTo: increaseCountButton.heightAnchor, multiplier: 1),
            counterStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            counterLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.topAnchor.constraint(equalTo: counterStackView.bottomAnchor, constant: topInset),
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

    private func updateUIForEditing() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: 886)
        titleLabel.text = "HABIT_EDITING".localized
        createButton.setTitle("SAVE".localized, for: .normal)
        trackerNameTextField.text = trackerToEdit?.name
        decreaseCountButton.backgroundColor = trackerToEdit?.color
        increaseCountButton.backgroundColor = trackerToEdit?.color
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let emojiIndex = viewModel?.giveEmojiIndex() ?? IndexPath(row: 0, section: 0)
            let colorIndex = viewModel?.giveColorIndex() ?? IndexPath(row: 0, section: 0)
            self.emojiCollectionView.selectItem(at: emojiIndex, animated: true, scrollPosition: .centeredHorizontally)
            self.collectionView(self.emojiCollectionView,
                                didSelectItemAt: emojiIndex)
            self.colorCollectionView.selectItem(at: colorIndex, animated: true, scrollPosition: .centeredHorizontally)
            self.collectionView(self.colorCollectionView,
                                didSelectItemAt: colorIndex)
        }
    }
}
