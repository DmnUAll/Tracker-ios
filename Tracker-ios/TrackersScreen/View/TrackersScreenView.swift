import UIKit

// MARK: - TrackersScreenViewDelegate protocol
protocol TrackersScreenViewDelegate: AnyObject {
    func cancelSearch()
    func showFilters()
}

// MARK: - TrackersScreenView
final class TrackersScreenView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: TrackersScreenViewDelegate?

    let noDataImage = UICreator.shared.makeImageView(withImage: K.ImageNames.noDataImage)
    let noDataLabel = UICreator.shared.makeLabel(text: "Что будем отслеживать?",
                                                 font: UIFont.appFont(.medium, withSize: 12))
    private let stackView = UICreator.shared.makeStackView(withAxis: .horizontal, andSpacing: 14)
    let searchTextField = UICreator.shared.makeSearchTextField()
    let cancelButton: UIButton = {
        let button = UICreator.shared.makeButton(withTitle: "Отменить",
                                                 font: UIFont.appFont(.regular, withSize: 17),
                                                 backgroundColor: .clear,
                                                 action: #selector(cancelButtonTapped))
        button.setTitleColor(.ypBlue, for: .normal)
        button.isHidden = true
        return button
    }()

    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerCell.self,
                                forCellWithReuseIdentifier: K.CollectionElementNames.trackerCell)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: K.CollectionElementNames.trackerHeader)
        collectionView.allowsMultipleSelection = false
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 80, right: 0)
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return collectionView
    }()
    let filterButton = UICreator.shared.makeButton(withTitle: "Фильтры",
                                                   font: UIFont.appFont(.regular, withSize: 17),
                                                   backgroundColor: .ypBlue,
                                                   action: #selector(filterButtonTapped))

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
extension TrackersScreenView {

    @objc private func cancelButtonTapped() {
        delegate?.cancelSearch()
    }

    @objc private func filterButtonTapped() {
        delegate?.showFilters()
    }

    private func setupAutolayout() {
        toAutolayout()
        noDataImage.toAutolayout()
        noDataLabel.toAutolayout()
        stackView.toAutolayout()
        collectionView.toAutolayout()
        filterButton.toAutolayout()
    }

    private func addSubviews() {
        addSubview(noDataImage)
        addSubview(noDataLabel)
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(cancelButton)
        addSubview(stackView)
        addSubview(collectionView)
        addSubview(filterButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noDataImage.heightAnchor.constraint(equalToConstant: 80),
            noDataImage.widthAnchor.constraint(equalTo: noDataImage.heightAnchor),
            noDataImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            noDataImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            noDataLabel.topAnchor.constraint(equalTo: noDataImage.bottomAnchor, constant: 8),
            noDataLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -17)
        ])
    }
}
