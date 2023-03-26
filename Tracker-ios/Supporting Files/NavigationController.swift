import UIKit

// MARK: - NavigationController
final class NavigationController: UINavigationController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationController(forVC: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension NavigationController {

    @objc private func addTapped() {
        present(TrackerChoosingScreenController(), animated: true)
    }

    private func configureNavigationController(forVC viewController: UIViewController) {
        navigationBar.tintColor = .ypBlack
        navigationBar.prefersLargeTitles = true
        if viewController is TrackersScreenController {
            navigationBar.topItem?.title = "Трекеры"
            navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                       target: nil,
                                                                       action: #selector(addTapped))
            let datePicker = UICreator.shared.makeDatePicker()
            datePicker.toAutolayout()
            navigationBar.addSubview(datePicker)
            NSLayoutConstraint.activate([
                datePicker.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
                datePicker.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -11),
                datePicker.heightAnchor.constraint(equalToConstant: 34)
            ])
        }
    }
}
