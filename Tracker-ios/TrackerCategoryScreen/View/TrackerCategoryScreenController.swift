import UIKit

// MARK: - TrackerCategoryConfigurationDelegate protocol
protocol TrackerCategoryConfigurationDelegate: AnyObject {
    var previousSelectedCategory: String { get }
    func updateCategory(withCategory category: String)
}

// MARK: - TrackerCategoryScreenController
final class TrackerCategoryScreenController: UIViewController {

    // MARK: - Properties and Initializers
    weak var delegate: TrackerCategoryConfigurationDelegate?
    private var viewModel: TrackerCategoryScreenViewModel?

    private let titleLabel = UICreator.shared.makeLabel(text: "CATEGORY".localized,
                                                        font: UIFont.appFont(.medium, withSize: 16))
    private let noDataImage = UICreator.shared.makeImageView(withImage: K.ImageNames.noDataYet)
    private let noDataLabel = UICreator.shared.makeLabel(text: "WHAT_TO_CREATE".localized,
                                                 font: UIFont.appFont(.medium, withSize: 12))
    private let categoriesTableView: UITableView = {
        let tableView = UICreator.shared.makeTableView()
        tableView.register(CategorySelectionCell.self,
                           forCellReuseIdentifier: K.CollectionElementNames.categorySelectionCell)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .ypWhite
        return tableView
    }()
    private let addButton = UICreator.shared.makeButton(withTitle: "ADD_CATEGORY".localized,
                                                        action: #selector(addButtonTapped))

    convenience init(delegate: TrackerCategoryConfigurationDelegate?, viewModel: TrackerCategoryScreenViewModel) {
        self.init()
        self.delegate = delegate
        self.viewModel = viewModel
        bind()
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        setupAutolayout()
        addSubviews()
        setupConstraints()
        viewModel?.selectPreviouslyChoosenCategory(withName: delegate?.previousSelectedCategory ?? "")
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
    }
}

// MARK: - Helpers
extension TrackerCategoryScreenController {

    @objc private func addButtonTapped() {
        present(CategoryCreationScreenController(delegate: viewModel), animated: true)
    }

    private func setupAutolayout() {
        titleLabel.toAutolayout()
        noDataImage.toAutolayout()
        noDataLabel.toAutolayout()
        categoriesTableView.toAutolayout()
        addButton.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(noDataImage)
        view.addSubview(noDataLabel)
        view.addSubview(categoriesTableView)
        view.addSubview(addButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            noDataImage.heightAnchor.constraint(equalToConstant: 80),
            noDataImage.widthAnchor.constraint(equalTo: noDataImage.heightAnchor),
            noDataImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.topAnchor.constraint(equalTo: noDataImage.bottomAnchor, constant: 8),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -24)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$isDataExist.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.showTableView()
            } else {
                self.hideTableView()
            }
        }
        viewModel.$needToReloadTable.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.categoriesTableView.reloadData()
            }
        }
        viewModel.$batchUpdates.bind { [weak self] newValue in
            guard let self,
                  let newValue else { return }
            self.categoriesTableView.performBatchUpdates {
                let insertedIndexPaths = newValue.insertedIndexes.map { IndexPath(item: $0, section: 0) }
                let deletedIndexPaths = newValue.deletedIndexes.map { IndexPath(item: $0, section: 0) }
                self.categoriesTableView.insertRows(at: insertedIndexPaths, with: .automatic)
                self.categoriesTableView.deleteRows(at: deletedIndexPaths, with: .fade)
            }
        }
    }

    func hideTableView() {
        noDataImage.isHidden = false
        noDataLabel.isHidden = false
        categoriesTableView.isHidden = true
    }

    func showTableView() {
        noDataImage.isHidden = true
        noDataLabel.isHidden = true
        categoriesTableView.isHidden = false
    }

    func showDeletionAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "CATEGORY_DELETION".localized,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "DELETE".localized,
                                         style: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.deleteItem(at: indexPath.row)
            self.categoriesTableView.reloadData()
            self.viewModel?.checkForData()
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TrackerCategoryScreenController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.giveNumberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UITableViewDelegate
extension TrackerCategoryScreenController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateCategory(withCategory: viewModel?.giveSelectedCategory(forIndexPath: indexPath) ?? "")
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            guard let self else { return UIMenu() }
            return UIMenu(children: [
                UIAction(title: "EDIT".localized) { [weak self] _ in
                    guard let viewModel = self?.viewModel else { return }
                    viewModel.editItem(at: indexPath.row)
                    self?.present(CategoryCreationScreenController(delegate: viewModel), animated: true)
                },
                UIAction(title: "DELETE".localized, attributes: .destructive) { [weak self] _ in
                    self?.showDeletionAlert(for: indexPath)
                }
            ])
        })
    }
}
