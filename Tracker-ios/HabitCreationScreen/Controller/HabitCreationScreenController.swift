import UIKit

// MARK: - HabitCreationScreenController
final class HabitCreationScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    let habitCreationScreenView = HabitCreationScreenView()
    private var presenter: HabitCreationScreenPresenter?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .ypBlue
        view.addSubview(habitCreationScreenView)
        setupConstraints()
        presenter = HabitCreationScreenPresenter(viewController: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Helpers
extension HabitCreationScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitCreationScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitCreationScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            habitCreationScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habitCreationScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension HabitCreationScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HabitCreationScreenController: UITableViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension HabitCreationScreenController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
