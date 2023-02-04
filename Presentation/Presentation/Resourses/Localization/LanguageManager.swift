//
//  LanguageManager.swift
//  Presentation
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation

public enum Language: String {
    case en, el
    
    static var allLanguages: [Language] {
        return [.en, .el]
    }
}

public class LanguageManager {
    
    private struct Defaults {
        static let keyCurrentLanguage = "KeyCurrentLanguage"
    }
    
    public static let shared: LanguageManager = LanguageManager()
    
    public static var appLanguages: [Language] = Language.allLanguages
    
    public var languageCode: String {
        return language.rawValue
    }
    
    public var currentLanguage: Language {
        var currentLanguage = UserDefaults.standard.object(forKey: Defaults.keyCurrentLanguage)
        if currentLanguage == nil {
            currentLanguage = Locale.preferredLanguages[0]
        }
        
        if let currentLanguage = currentLanguage as? String,
            let lang = Language(rawValue: currentLanguage.truncate(length: 2)) {
            return lang
        }
        return Language.en
    }
    
    public func switchToLanguage(_ lang: Language, notify: Bool = false) {
        language = lang
    }
    
    public func clearLanguages() {
        UserDefaults.standard.setValue(nil, forKey: Defaults.keyCurrentLanguage)
    }
    
    private var localeBundle: Bundle?
    
    public func getLocalBundle() -> Bundle {
        if let bundle = localeBundle {
            return bundle
        } else {
            return .main
        }
    }
    
    fileprivate var language: Language = Language.en {
        didSet {
            let currentLanguage = language.rawValue
            UserDefaults.standard.setValue(currentLanguage, forKey: Defaults.keyCurrentLanguage)
            UserDefaults.standard.synchronize()
            
            setLocaleWithLanguage(currentLanguage)
        }
    }
    
    // MARK: - LifeCycle
    
    private init() {
        language = .el
        // call next method to support more than one languages. For now, we support only Greek, el
        //prepareDefaultLocaleBundle()
    }
    
    // MARK: - Private
    
    private func prepareDefaultLocaleBundle() {
        var currentLanguage = UserDefaults.standard.object(forKey: Defaults.keyCurrentLanguage)
        if currentLanguage == nil {
            currentLanguage = Locale.preferredLanguages[0]
        }
        
        if let currentLanguage = currentLanguage as? String {
            updateCurrentLanguageWithName(currentLanguage)
        }
    }
    
    private func updateCurrentLanguageWithName(_ languageName: String) {
        if let lang = Language(rawValue: languageName) {
            language = lang
        }
    }
    
    /**
     # SOS!
     Use `Bundle.main` here in order to provide Localizable strings from Main Application.
     in order to make presentation translations agnostic.
     */
    private func setLocaleWithLanguage(_ selectedLanguage: String) {
        if let pathSelected = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
            let bundleSelected = Bundle(path: pathSelected) {
            localeBundle = bundleSelected
        } else if let pathDefault = Bundle.main.path(forResource: Language.en.rawValue, ofType: "lproj"),
            let bundleDefault = Bundle(path: pathDefault) {
            localeBundle = bundleDefault
        }
    }
}
