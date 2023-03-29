import UIKit

// MARK: - DateReceiveDelegate protocol
protocol DateReceiveDelegate: AnyObject {
    func applyDate(_ date: Date)
}

// MARK: - NavigationController
final class NavigationController: UINavigationController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    weak var dateReceiverDelegate: DateReceiveDelegate?

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
        navigationController?.viewControllers.first?.view.endEditing(true)
        present(TrackerChoosingScreenController(), animated: true)
    }

    @objc private func datePicked(_ sender: UIDatePicker) {
        dateReceiverDelegate?.applyDate(sender.date)
    }

    private func configureNavigationController(forVC viewController: UIViewController) {
        navigationBar.tintColor = .ypBlack
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.ypBlack]
        navigationBar.prefersLargeTitles = true
        if viewController is TrackersScreenController {
            navigationBar.topItem?.title = "Трекеры"
            navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                       target: nil,
                                                                       action: #selector(addTapped))
            let datePicker = UICreator.shared.makeDatePicker()
            datePicker.toAutolayout()
            datePicker.addTarget(nil, action: #selector(datePicked(_:)), for: .valueChanged)
            navigationBar.addSubview(datePicker)
            NSLayoutConstraint.activate([
                datePicker.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
                datePicker.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -11),
                datePicker.heightAnchor.constraint(equalToConstant: 34)
            ])
        }
    }
}
