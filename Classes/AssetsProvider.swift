//
//  AssetsProvider.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 26.12.2021.
//

import UIKit

final class AssetsProvider {
    static var arrowLeftImage: UIImage? {
        image(named: "arrow-left")
    }
    
    static var arrowRightImage: UIImage? {
        image(named: "arrow-right")
    }
    
    static var textButtonColor: UIColor? {
        color(named: "text-button-color")
    }
    
    static var weekdayLabelColor: UIColor? {
        color(named: "weekday-label-color")
    }
    
    static var allDoneColor: UIColor? {
        color(named: "all-done-color")
    }
    
    static var someDoneColor: UIColor? {
        color(named: "some-done-color")
    }
    
    static var nothingDoneColor: UIColor? {
        color(named: "nothing-done-color")
    }
    
    static func image(named: String) -> UIImage? {
        UIImage(
            named: named,
            in: Bundle(for: self),
            compatibleWith: nil
        )
    }
    
    static func color(named: String) -> UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(
                named: named,
                in: Bundle(for: self),
                compatibleWith: nil
            )
        } else {
           return nil
        }
    }
}
