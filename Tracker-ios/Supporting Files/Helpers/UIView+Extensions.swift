import UIKit

extension UIView {

    func toAutolayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addKeyboardHiddingFeature() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    func gradientBorder(colors: [UIColor], isVertical: Bool) {
        self.layer.masksToBounds = true

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradient.colors = colors.map({ (color) -> CGColor in
            color.cgColor
        })

        if isVertical {
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        } else {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }

        let shape = CAShapeLayer()
        shape.lineWidth = 1.0
        shape.path = UIBezierPath(roundedRect: gradient.frame.insetBy(dx: 1.0, dy: 1.0),
                                  cornerRadius: self.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        self.layer.addSublayer(gradient)
        gradient.zPosition = 0.0
    }
}
