//
//  Font.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import Foundation
import UIKit

public class BundleAccessor {
    let bundle = Bundle(for: BundleAccessor.self)
}

public enum Font: String, CaseIterable {
    case MulishBlack = "Mulish-Black"
    case MulishBlackItalic = "Mulish-BlackItalic"
    case MulishBold = "Mulish-Bold"
    case MulishExtraBold = "Mulish-ExtraBold"
    case MulishExtraBoldItalic = "Mulish-ExtraBoldItalic"
    case MulishExtraLight = "Mulish-ExtraLight"
    case MulishExtraLightItalic = "Mulish-ExtraLightItalic"
    case MulishItalic = "Mulish-Italic"
    case MulishLight = "Mulish-Light"
    case MulishLightItalic = "Mulish-LightItalic"
    case MulishMedium = "Mulish-Medium"
    case MulishMediumItalic = "Mulish-MediumItalic"
    case MulishRegular = "Mulish-Regular"
    case MulishSemiBold = "Mulish-SemiBold"
    case MulishSemiBoldItalic = "Mulish-SemiBoldItalic"
    
    static var installed = false
    
    public static func install(from bundles: [Bundle]? = nil ) {
        Font.installed = true
        for each in Font.allCases {
            for bundle in bundles ?? [BundleAccessor().bundle] {
                if let cfURL = bundle.url(forResource:each.rawValue, withExtension: "ttf") {
                    CTFontManagerRegisterFontsForURL(cfURL as CFURL, .process, nil)
                } else {
                    assertionFailure("Could not find font:\(each.rawValue) in bundle:\(bundle)")
                }
            }
        }
    }
    
    public func of(size: CGFloat) -> UIFont {
        if Font.installed == false {
            Font.install()
        }
        guard let font = UIFont(name: self.rawValue, size: size) else {
            fatalError("\(self.rawValue) font is not installed, make sure it added in Info.plist and logged with Font.logAllAvailableFonts()")
        }
        return font
    }
    
    public static func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}
