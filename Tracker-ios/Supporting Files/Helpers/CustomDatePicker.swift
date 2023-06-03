//
//  CustomDatePicker.swift
//  Tracker-ios
//
//  Created by Илья Валито on 06.05.2023.
//

import UIKit

@available(iOS 14.0, *)
class MyCompactDatePicker: UIDatePicker {

    var textColorToSet = UIColor.black

    private var lblDate: UILabel?
    private var lblTime: UILabel?
    private var actionId: UIAction.Identifier?

    override func draw(_ rect: CGRect) {
        if preferredDatePickerStyle != .compact {
            preferredDatePickerStyle = .compact
        }
        super.draw(rect)
        findLabels()
        colorLabels()
        if actionId == nil {
            let action = UIAction(title: "colorLabels", handler: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.colorLabels()
                }
            })
            actionId = action.identifier
            addAction(action, for: .allEvents)
        }
    }

    private func colorLabels() {
        lblDate?.textColor = textColorToSet
        lblTime?.textColor = textColorToSet
    }

    private func findLabels() {
       if lblDate == nil || lblTime == nil {
            var num = 0
            recursFindLabels(view: self, number: &num)
       }
    }

    private func recursFindLabels(view: UIView, number: inout Int) {
        if let lbl = view as? UILabel {
            switch number {
            case 0:
                lblDate = lbl
            case 1:
                lblTime = lbl
            default:
                return
            }
            number += 1
            if number > 1 {
                return
            }
        }
        for subview in view.subviews {
            recursFindLabels(view: subview, number: &number)
        }
    }
}
