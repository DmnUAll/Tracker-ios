import UIKit

final class LaunchScreenPresenter {

    private weak var viewController: LaunchScreenController?

    init(viewController: LaunchScreenController? = nil) {
        self.viewController = viewController
    }
}
