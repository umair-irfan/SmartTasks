//
//  UIColor+Extension.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

extension UIColor {
    
    public static func color(_ hex: String, alpha: CGFloat = 1) -> UIColor {
        if hex.count > 7 || hex.count < 7 { return UIColor() }
        let r, g, b: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            let scan = Scanner(string: hexColor)
            var hexInteger: UInt64 = 0
            if scan.scanHexInt64(&hexInteger) {
                r = CGFloat((hexInteger >> 16) & 0xff) / 255
                g = CGFloat((hexInteger >> 08) & 0xff) / 255
                b = CGFloat((hexInteger >> 00) & 0xff) / 255
                return UIColor(red: r, green: g, blue: b, alpha: alpha)
            }
        }
        return UIColor()
    }
}
