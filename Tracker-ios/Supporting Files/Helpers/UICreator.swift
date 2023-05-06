import UIKit

struct UICreator {

    static let shared = UICreator()

    func makeLabel(text: String? = nil,
                   font: UIFont?,
                   color: UIColor = .ypBlack,
                   alignment: NSTextAlignment = .center,
                   andNumberOfLines numberOfLines: Int = 0
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = text
        return label
    }

    func makeView(bacgroundColor: UIColor = .clear, cornerRadius: CGFloat? = nil) -> UIView {
        let uiView = UIView()
        uiView.backgroundColor = bacgroundColor
        if let cornerRadius {
            uiView.layer.cornerRadius = cornerRadius
            uiView.layer.masksToBounds = true
        }
        return uiView
    }

    func makeImageView(withImage: String? = nil) -> UIImageView {
        let imageView = UIImageView()
        guard let imageName = withImage else { return imageView }
        imageView.image = UIImage(named: imageName)
        return imageView
    }

    func makeButton(withTitle title: String? = nil,
                    font: UIFont = UIFont.appFont(.medium, withSize: 16),
                    fontColor: UIColor = .ypWhite,
                    backgroundColor: UIColor = .ypBlack,
                    cornerRadius: CGFloat = 16,
                    action: Selector
    ) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = font
        button.setTitleColor(fontColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        button.addTarget(nil, action: action, for: .touchUpInside)
        return button
    }

    func makeTextField(withTarget action: Selector? = nil) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .ypGrayLight.withAlphaComponent(0.12)
        textField.textColor = .ypBlack
        textField.attributedPlaceholder = NSAttributedString(
            string: "Placeholder Text",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGray])
        if let button = textField.value(forKey: "clearButton") as? UIButton {
          button.tintColor = .ypGray
          button.setImage(UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        if let action {
            textField.addTarget(nil, action: action, for: .editingChanged)
        }
        return textField
    }

    func makeSearchTextField(withTarget action: Selector? = nil) -> UISearchTextField {
        let searchField = UISearchTextField()
        searchField.placeholder = "SEARCH".localized
        searchField.backgroundColor = .ypGrayLight.withAlphaComponent(0.12)
        searchField.textColor = .ypBlack
        searchField.attributedPlaceholder = NSAttributedString(string: searchField.placeholder ?? "",
                                                               attributes: [
                                                                NSAttributedString.Key.foregroundColor: UIColor.ypGray])
        if let leftView = searchField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor.ypGray
        }
        searchField.clearButtonMode = .never
        if let action {
            searchField.addTarget(nil, action: action, for: .editingChanged)
        }
        return searchField
    }

    func makeSwitch(withTag tag: Int) -> UISwitch {
        let uiSwitch = UISwitch(frame: .zero)
        uiSwitch.onTintColor = .ypBlue
        uiSwitch.tag = tag
        return uiSwitch
    }

    func makeStackView(withAxis axis: NSLayoutConstraint.Axis = .vertical,
                       distribution: UIStackView.Distribution = .fill,
                       align: UIStackView.Alignment = .fill,
                       andSpacing spacing: CGFloat = 16
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }

    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }

    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .ypGrayField.withAlphaComponent(0.3)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorColor = .ypGray
        return tableView
    }

    func makePageControll() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.isEnabled = false
        pageControl.backgroundColor = .clear
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        pageControl.numberOfPages = 2
        return pageControl
    }

    func makeDatePicker() -> UIDatePicker {
        let datePicker: UIDatePicker
        if #available(iOS 14.0, *) {
            datePicker = MyCompactDatePicker()
        } else {
            datePicker = UIDatePicker()
        }
        let dynamicColor = UIColor { (traits: UITraitCollection) -> UIColor in
            if traits.userInterfaceStyle == .light {
                return .ypGrayLight.withAlphaComponent(0.12)
            } else {
                return .ypBlack
            }
        }

        datePicker.backgroundColor = dynamicColor
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru")
        
        return datePicker
    }

    private func tintImage(image: UIImage, color: UIColor) -> UIImage {
           let size = image.size

           UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
           let context = UIGraphicsGetCurrentContext()
           image.draw(at: .zero, blendMode: CGBlendMode.normal, alpha: 1.0)

           context?.setFillColor(color.cgColor)
           context?.setBlendMode(CGBlendMode.sourceIn)
           context?.setAlpha(1.0)

           let rect = CGRect(x: CGPoint.zero.x, y: CGPoint.zero.y, width: image.size.width, height: image.size.height)
           UIGraphicsGetCurrentContext()?.fill(rect)
           let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()

           return tintedImage ?? UIImage()
       }
}
