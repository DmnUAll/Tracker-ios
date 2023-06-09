import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTabBarController()
    }
}

// MARK: - Helpers
extension TabBarController {

    private func configureTabBarController() {
        tabBar.backgroundColor = .ypWhite
        let trackersNavigationController = NavigationController(rootViewController: TrackersScreenController())
        let statisticsNavigationController = NavigationController(rootViewController: StatisticsScreenController())
        self.viewControllers = [
            configureTab(withController: trackersNavigationController,
                         title: "TRACKERS".localized,
                         andImage: UIImage(named: K.IconNames.trackerIcon) ?? UIImage()),
            configureTab(withController: statisticsNavigationController,
                         title: "STATISTICS".localized,
                         andImage: UIImage(named: K.IconNames.statisticsIcon) ?? UIImage())
        ]
    }

    private func configureTab(withController viewController: UIViewController,
                              title: String? = nil,
                              andImage image: UIImage
    ) -> UIViewController {
        let tab = viewController
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        tab.tabBarItem = tabBarItem
        return tab
    }
}
