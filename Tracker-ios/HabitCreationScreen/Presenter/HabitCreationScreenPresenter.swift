import UIKit

// MARK: - HabitCreationScreeenPresenter
final class HabitCreationScreenPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: HabitCreationScreenController?

    init(viewController: HabitCreationScreenController? = nil) {
        self.viewController = viewController
    }
}

// MARK: - Helpers
extension HabitCreationScreenPresenter {

//    func fillUI() {
//        guard let viewController else { return }
//        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height
//        for index in 0...1 {
//            let text = onboardingTexts[index]
//            let scrollViewPage = UICreator.shared.makeView()
//            scrollViewPage.frame = CGRect(x: width * CGFloat(index),
//                                          y: 0,
//                                          width: width,
//                                          height: height)
//            var imageView: UIImageView
//            if index == 0 {
//                imageView = UICreator.shared.makeImageView(withImage: K.ImageNames.firstOnboardingImage)
//            } else {
//                imageView = UICreator.shared.makeImageView(withImage: K.ImageNames.secondOnboardingImage)
//            }
//            imageView.toAutolayout()
//            scrollViewPage.addSubview(imageView)
//            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
//            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
//            let label = UICreator.shared.makeLabel(text: text, font: UIFont.appFont(.bold, withSize: 32))
//            label.toAutolayout()
//            scrollViewPage.addSubview(label)
//            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16).isActive = true
//            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16).isActive = true
//            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -304).isActive = true
//            viewController.onboardingScreenView.scrollView.addSubview(scrollViewPage)
//        }
//    }

    func configureCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = (tableView.dequeueReusableCell(withIdentifier: K.CollectionElementNames.categoryCell,
                                                  for: indexPath) as? CategoryCell) ?? UITableViewCell()
        } else {
            cell = (tableView.dequeueReusableCell(withIdentifier: K.CollectionElementNames.scheduleCell,
                                                  for: indexPath) as? ScheduleCell) ?? UITableViewCell()
        }
        return cell
    }
}
