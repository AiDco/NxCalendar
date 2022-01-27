//
//  UIFont+Extension.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 26.12.2021.
//

import UIKit

extension UIFont {
    private final class BundleToken { }
    
    private static var isFontRegistered: Bool = false
    
    static func registerFont(with fontName: String) {
        guard !isFontRegistered,
              let url = Bundle(for: BundleToken.self).url(
                    forResource: fontName,
                    withExtension: "ttf"
              ),
              CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        else { return }
        
        isFontRegistered = true
    }
    
    static func boldDMSans(of size: CGFloat) -> UIFont {
        registerFont(with: "DMSans-Bold")
        return UIFont(name: "DMSans-Bold", size: size)!
    }
}
