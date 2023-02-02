//
//  AppConfig.swift
//  CleanArchitectureTemplate
//
//  Created by thanos kottaridis on 29/1/23.
//

import Foundation

final class AppConfig {
    
    lazy var hasAlreadyRun: Bool = false
    
    lazy var appBundleID: String = {
        return path("CFBundleIdentifier")
    }()
    
    lazy var appVersion: String = {
        let version = path("CFBundleShortVersionString")
        let buildNo = path("CFBundleVersion")
        return "\(version)(\(buildNo))"
    }()
    
    lazy var appAbsoluteVersion: String = {
        return path("CFBundleShortVersionString")
    }()
    
    lazy var appApiBaseUrl: String = {
        return path("Environment", "App Api Base URL")
    }()

    private func path(_ keys: String...) -> String {
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
