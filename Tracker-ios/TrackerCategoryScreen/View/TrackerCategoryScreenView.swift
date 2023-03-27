import UIKit

// MARK: - TrackerCategoryScreenViewDelegate protocol
protocol TrackerCategoryScreenViewDelegate: AnyObject {
    func createNewCategory()
}

// MARK: - TrackerCategoryScreenView
final class TrackerCategoryScreenView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: TrackerCategoryScreenViewDelegate?

    let titleLabel = UICreator.shared.makeLabel(text: "Категория",
                                                        font: UIFont.appFont(.medium, withSize: 16))

    let noDataImage = UICreator.shared.makeImageView(withImage: K.ImageNames.noDataImage)

    let noDataLabel = UICreator.shared.makeLabel(text: "Привычки и события можно объединить по смыслу",
                                                 font: UIFont.appFont(.medium, withSize: 12))
    let categoriesTableView: UITableView = {
        let tableView = UICreator.shared.makeTableView()
        tableView.register(CategorySelectionCell.self,
                           forCellReuseIdentifier: K.CollectionElementNames.categorySelectionCell)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    let addButton = UICreator.shared.makeButton(withTitle: "Добавить категорию",
                                                        action: #selector(addButtonTapped))

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
extension TrackerCategoryScreenView {

    @objc private func addButtonTapped() {
        delegate?.createNewCategory()
    }

    private func setupAutolayout() {
        toAutolayout()
        titleLabel.toAutolayout()
        noDataImage.toAutolayout()
        noDataLabel.toAutolayout()
        categoriesTableView.toAutolayout()
        addButton.toAutolayout()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(noDataImage)
        addSubview(noDataLabel)
        addSubview(categoriesTableView)
        addSubview(addButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            noDataImage.heightAnchor.constraint(equalToConstant: 80),
            noDataImage.widthAnchor.constraint(equalTo: noDataImage.heightAnchor),
            noDataImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            noDataImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            noDataLabel.topAnchor.constraint(equalTo: noDataImage.bottomAnchor, constant: 8),
            noDataLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoriesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoriesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -38)
        ])
    }
}
