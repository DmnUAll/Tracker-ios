import UIKit

extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? .red }
    static var ypBlue: UIColor { UIColor(named: "YP Blue") ?? .red }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? .red }
    static var ypGrayField: UIColor { UIColor(named: "YP Gray Field") ?? .red }
    static var ypGrayLight: UIColor { UIColor(named: "YP Gray Light") ?? .red }
    static var ypRedLight: UIColor { UIColor(named: "YP Red Light") ?? .red }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? .red }
    static var tr0: UIColor { UIColor(named: "T0") ?? .red}
    static var tr1: UIColor { UIColor(named: "T1") ?? .red}
    static var tr2: UIColor { UIColor(named: "T2") ?? .red}
    static var tr3: UIColor { UIColor(named: "T3") ?? .red}
    static var tr4: UIColor { UIColor(named: "T4") ?? .red}
    static var tr5: UIColor { UIColor(named: "T5") ?? .red}
    static var tr6: UIColor { UIColor(named: "T6") ?? .red}
    static var tr7: UIColor { UIColor(named: "T7") ?? .red}
    static var tr8: UIColor { UIColor(named: "T8") ?? .red}
    static var tr9: UIColor { UIColor(named: "T9") ?? .red}
    static var tr10: UIColor { UIColor(named: "T10") ?? .red}
    static var tr11: UIColor { UIColor(named: "T11") ?? .red}
    static var tr12: UIColor { UIColor(named: "T12") ?? .red}
    static var tr13: UIColor { UIColor(named: "T13") ?? .red}
    static var tr14: UIColor { UIColor(named: "T14") ?? .red}
    static var tr15: UIColor { UIColor(named: "T15") ?? .red}
    static var tr16: UIColor { UIColor(named: "T16") ?? .red}
    static var tr17: UIColor { UIColor(named: "T17") ?? .red}

    func hexString() -> String {
        let components = self.cgColor.components
        let red: CGFloat = components?[0] ?? 0.0
        let green: CGFloat = components?[1] ?? 0.0
        let blue: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(red * 255)),
            lroundf(Float(green * 255)),
            lroundf(Float(blue * 255))
        )
    }

    func color(from hex: String) -> UIColor {
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
