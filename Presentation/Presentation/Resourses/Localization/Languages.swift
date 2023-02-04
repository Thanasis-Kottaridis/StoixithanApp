//
//  Languages.swift
//  Presentation
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation

final public class Languages {
    public static func tr(_ key: String) -> String {
        let s = NSLocalizedString(key, bundle: LanguageManager.shared.getLocalBundle(), value: key, comment: "")
        return s
    }
    
    public static func tr(_ key: String, _ args: [CVarArg]) -> String {
        let format = NSLocalizedString(key, bundle: LanguageManager.shared.getLocalBundle(), value: key, comment: "")
        return String(format: format, arguments: args)
    }
}
