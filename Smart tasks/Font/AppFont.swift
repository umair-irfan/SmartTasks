//
//  AppFont.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

protocol FontStyleType: LanguageConditionable {
    func getRegular(_ language: Language?) -> FontFamily
    func getBold(_ language: Language?) -> FontFamily
}

enum FontFamily: String {
    
    case AmsiProBold = "AmsiPro-Bold"
    case AmsiProRegular = "AmsiPro-Regular"
    
}

enum AppFont: Int {
    
    case regular = 10
    case bold = 15
    
    static let allValues: [AppFont] = [.regular, .bold]
    
    func fontFamily(_ language: Language? = nil) -> FontFamily {
        switch self {
        case .regular:
            return self.getRegular(language)
        case .bold:
            return self.getBold(language)
        }
    }
    
    func getFont(_ style: AppFontEngine, lang: Language? = nil) -> UIFont {
        return UIFont(name: self.fontFamily().rawValue, size: style.fontSize) ?? UIFont.systemFont(ofSize: style.fontSize)
    }
    
}

extension AppFont: FontStyleType {
    
    func getRegular(_ language: Language?) -> FontFamily {
        switch getLanguage() {
        case .English:
            return .AmsiProRegular
        default:
            return .AmsiProRegular
        }
    }
    
    
    func getBold(_ language: Language?) -> FontFamily {
        switch getLanguage() {
        case .English:
            return .AmsiProBold
        default:
            return .AmsiProBold
        }
    }
}
