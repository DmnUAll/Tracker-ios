import UIKit

// MARK: - TrackerChoosingScreenController
final class TrackerChoosingScreenController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private let trackerChoosingScreenView = TrackerChoosingScreenView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.addSubview(trackerChoosingScreenView)
        view.backgroundColor = .ypWhite
        setupConstraints()
        trackerChoosingScreenView.delegate = self
    }
}

// MARK: - Helpers
extension TrackerChoosingScreenController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerChoosingScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerChoosingScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            trackerChoosingScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerChoosingScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TrackerChoosingScreenViewDelegate
extension TrackerChoosingScreenController: TrackerChoosingScreenViewDelegate {
    func proceedToHabit() {
        present(HabitCreationScreenController(), animated: true)
    }

    func proceedToEvent() {
        print(#function)
    }
}
