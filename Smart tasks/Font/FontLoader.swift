//
//  FontLoader.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

// Fatory Patern
public class FontLoader {
    
     public class func load() {
        loadFont(with: "AmsiPro-Bold")
        loadFont(with: "AmsiPro-Regular")
    }
    
    private class func loadFont(with family: String) {
        if let fontUrl = Bundle(for: FontLoader.self).url(forResource: family, withExtension: "otf"),
           let dataProvider = CGDataProvider(url: fontUrl as CFURL),
           let newFont = CGFont(dataProvider) {
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(newFont, &error)
            {
                print("Error loading \(family)")
            } else {
                print("Loaded Font: \(family) ✅")
            }
        } else {
            assertionFailure("Error loading \(family)")
        }
    }
}
