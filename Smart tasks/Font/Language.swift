//
//  Lanuage.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import Foundation

enum Language: String, Decodable {
    
    case English = "en"
    case None
    
    static let allLanguage = [English]
    
    public init( from value: String) {
        switch value.lowercased() {
        case "en", "english":
            self = .English
        default:
            self = .None
        }
    }
}

protocol LanguageConditionable {
    func getLanguage() -> Language
}

extension LanguageConditionable {
    func getLanguage() -> Language {
        guard let _ = Bundle.main.preferredLocalizations.first else {
            return .English
        }
        return .English
    }
}
