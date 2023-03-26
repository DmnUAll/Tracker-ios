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

    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .ypGrayLight.withAlphaComponent(0.12)
        return textField
    }

    func makeSearchTextField() -> UISearchTextField {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.backgroundColor = .ypGrayLight.withAlphaComponent(0.12)
        return searchField
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
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .ypGrayLight.withAlphaComponent(0.12)
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru")
        return datePicker
    }
}
