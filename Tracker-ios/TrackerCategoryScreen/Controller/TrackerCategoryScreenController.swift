import UIKit

// MARK: - TrackerCategoryConfigurationDelegate protocol
protocol TrackerCategoryConfigurationDelegate: AnyObject {
    var previousSelectedCategory: String { get }
    func updateCategory(withCategory category: String)
}

// MARK: - TrackerCategoryScreenController
final class TrackerCategoryScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let trackerCategoryScreenView = TrackerCategoryScreenView()
    private var presenter: TrackerCategoryScreenPresenter?
    weak var delegate: TrackerCategoryConfigurationDelegate?

    convenience init(delegate: TrackerCategoryConfigurationDelegate?) {
        self.init()
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addSubview(trackerCategoryScreenView)
        setupConstraints()
        hideTableView()
        presenter = TrackerCategoryScreenPresenter(viewController: self)
        presenter?.selectPreviouslyChoosenCategory(withName: delegate?.previousSelectedCategory ?? "")
        trackerCategoryScreenView.delegate = self
        trackerCategoryScreenView.categoriesTableView.dataSource = self
        trackerCategoryScreenView.categoriesTableView.delegate = self
    }
}

// MARK: - Helpers
extension TrackerCategoryScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerCategoryScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCategoryScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            trackerCategoryScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerCategoryScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func hideTableView() {
        trackerCategoryScreenView.noDataImage.isHidden = false
        trackerCategoryScreenView.noDataLabel.isHidden = false
        trackerCategoryScreenView.categoriesTableView.isHidden = true
    }

    func showTableView() {
        trackerCategoryScreenView.noDataImage.isHidden = true
        trackerCategoryScreenView.noDataLabel.isHidden = true
        trackerCategoryScreenView.categoriesTableView.isHidden = false
    }

    func showDeletionAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "CATEGORY_DELETION".localized,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "DELETE".localized,
                                         style: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.deleteItem(at: indexPath.row)
            self.trackerCategoryScreenView.categoriesTableView.reloadData()
            self.presenter?.checkForData()
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
        presenter?.giveNumberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UITableViewDelegate
extension TrackerCategoryScreenController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateCategory(withCategory: presenter?.giveSelectedCategory(forIndexPath: indexPath) ?? "")
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            guard let self else { return nil }
            return UIMenu(children: [
                UIAction(title: "EDIT".localized) { _ in
                    self.presenter?.editItem(at: indexPath.row)
                },
                UIAction(title: "DELETE".localized, attributes: .destructive) { _ in
                    self.showDeletionAlert(for: indexPath)
                }
            ])
        })
    }
}

// MARK: - HabitCreationScreenViewDelegate
extension TrackerCategoryScreenController: TrackerCategoryScreenViewDelegate {

    func createNewCategory() {
        present(CategoryCreationScreenController(delegate: presenter), animated: true)
    }
}
