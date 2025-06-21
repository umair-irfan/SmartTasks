//
//  FontEngine.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

enum AppFontEngine: Int {
    
    // MARK: Heading Fonts
    case h1 = 1
    case h2 = 2
    
    //MARK: Body Fonts
    case b1 = 3
    case b2 = 4
    
    //MARK: Title Fotns
    case t1 = 5
    case t2 = 6
    
    
    private var iphoneFontSize: CGFloat {
        switch self {
        case .h1:
            return 18
        case .h2:
            return 15
        case .b1:
            return 15
        case .b2:
            return 10
        case .t1:
            return 15
        case .t2:
            return 13
        }
    }
    
    public var fontSize: CGFloat {
        return iphoneFontSize
    }
}
