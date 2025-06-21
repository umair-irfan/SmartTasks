//
//  AppColor.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//
import UIKit
 
public enum AppColor:  Int {
    
    case primaryText = 0
    case secondaryText = 1
    case background = 2
    case seperator = 3
    
    case clear
    case failure
    case sucess
    case white
    
    private var colorCode: String {
        switch self {
        case .primaryText:
            return "#EF4B5E"
        case .secondaryText:
            return "#F3F4F6"
        case .background:
            return "#FFDE61"
        case .clear:
            return "#000000"
        case .seperator:
            return "#F6EFDE"
        case .failure:
            return "#EF4B5E"
        case .sucess:
            return "#01897B"
        case .white:
            return "#FFFFFF"
        }
    }
    
    var cgColor: CGColor {
        return self.color.cgColor
    }
    
    var color: UIColor {
        switch self {
        case .primaryText:
            return AppColor.primaryText.color(with: 1)
        case .secondaryText:
            return AppColor.secondaryText.color(with: 1)
        case .background:
            return AppColor.background.color(with: 1)
        case .seperator:
            return AppColor.seperator.color(with: 1)
        case .clear:
            return AppColor.clear.color(with: 1)
        case .failure:
            return AppColor.failure.color(with: 1)
        case .sucess:
            return AppColor.sucess.color(with: 1)
        case .white:
            return AppColor.white.color(with: 1)
        }
    }
    
    func color(with opacity: CGFloat) -> UIColor {
        return UIColor.color(self.colorCode, alpha: opacity)
    }
}
