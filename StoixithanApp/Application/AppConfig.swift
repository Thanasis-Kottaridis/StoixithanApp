//
//  AppConfig.swift
//  CleanArchitectureTemplate
//
//  Created by thanos kottaridis on 29/1/23.
//

import Foundation
import Domain
import Data

final class AppConfig{
    
    static var hasAlreadyRun: Bool = false
    
    static var appBundleID: String = {
        return path("CFBundleIdentifier")
    }()
    
    static var appVersion: String = {
        let version = path("CFBundleShortVersionString")
        let buildNo = path("CFBundleVersion")
        return "\(version)(\(buildNo))"
    }()
    
    static var appAbsoluteVersion: String = {
        return path("CFBundleShortVersionString")
    }()
    
    static var appApiBaseUrl: String = {
        return path("Environment", "App Api Base URL")
    }()

    private static func path(_ keys: String...) -> String {
        var current = Bundle.main.infoDictionary
        for (index, key) in keys.enumerated() {
            if index == keys.count - 1 {
                guard let
                        result = (current?[key] as? String)?.replacingOccurrences(of: "\\", with: ""),
                      !result.isEmpty else {
                    assertionFailure(keys.joined(separator: " -> ").appending(" not found"))
                    return ""
                }
                return result
            }
            current = current?[key] as? [String: Any]
        }
        assertionFailure(keys.joined(separator: " -> ").appending(" not found"))
        return ""
    }
    
}

// MARK: - Default Data AppConfig
class DataAppConfigImpl: DataAppConfig {
    var appApiBaseUrl: String {
        return AppConfig.appApiBaseUrl
    }
}
