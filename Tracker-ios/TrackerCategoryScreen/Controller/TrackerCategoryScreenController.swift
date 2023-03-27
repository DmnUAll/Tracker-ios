import UIKit

// MARK: - TrackerCategoryScreenController
final class TrackerCategoryScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let trackerCategoryScreenView = TrackerCategoryScreenView()
    private var presenter: TrackerCategoryScreenPresenter?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        view.addSubview(trackerCategoryScreenView)
        setupConstraints()
        hideTableView()
        presenter = TrackerCategoryScreenPresenter(viewController: self)
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
//            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
            tableView.setNeedsLayout()
        }
    }
}

// MARK: - HabitCreationScreenViewDelegate
extension TrackerCategoryScreenController: TrackerCategoryScreenViewDelegate {

    func createNewCategory() {
        present(CategoryCreationScreenController(), animated: true)
    }
}
