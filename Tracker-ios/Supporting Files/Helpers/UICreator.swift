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

    func makeView(bacgroundColor: UIColor = .clear) -> UIView {
        let uiView = UIView()
        uiView.backgroundColor = bacgroundColor
        return uiView
    }

    func makeImageView(withImage: String?) -> UIImageView {
        let imageView = UIImageView()
        guard let imageName = withImage else { return imageView }
        imageView.image = UIImage(named: imageName)
        return imageView
    }

    func makeButton(withTitle title: String? = nil,
                    backgroundColor: UIColor = .ypBlack,
                    cornerRadius: CGFloat = 16,
                    action: Selector
    ) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont.appFont(.medium, withSize: 16)
        button.titleLabel?.textColor = .ypWhite
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        button.addTarget(nil, action: action, for: .touchUpInside)
        return button
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
}
