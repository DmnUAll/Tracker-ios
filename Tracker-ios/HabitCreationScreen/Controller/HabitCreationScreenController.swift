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
        view.backgroundColor = .ypWhite
        view.addSubview(habitCreationScreenView)
        setupConstraints()
        presenter = HabitCreationScreenPresenter(viewController: self)
        habitCreationScreenView.optionsTableView.dataSource = self
        habitCreationScreenView.optionsTableView.delegate = self
        habitCreationScreenView.emojiCollectionView.dataSource = self
        habitCreationScreenView.emojiCollectionView.delegate = self
        habitCreationScreenView.colorCollectionView.dataSource = self
        habitCreationScreenView.colorCollectionView.delegate = self
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UITableViewDelegate
extension HabitCreationScreenController: UITableViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension HabitCreationScreenController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.giveNumberOfItems(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        presenter?.configureCell(forCollectionView: collectionView, atIndexPath: indexPath) ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HabitCreationScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        presenter?.giveItemSize(forCollectionView: collectionView) ?? CGSize()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        presenter?.giveLineSpacing(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        presenter?.giveItemSpacing(forCollectionView: collectionView) ?? 0
    }
}

extension HabitCreationScreenController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
            cell.frameView.isHidden = false
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
            cell.frameView.layer.borderWidth = 3
        }
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
