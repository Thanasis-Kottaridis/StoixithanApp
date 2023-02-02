//
//  DataAppConfig.swift
//  Data
//
//  Created by thanos kottaridis on 2/2/23.
//

import Foundation

public protocol DataAppConfig {
    var appApiBaseUrl: String { get }
}

public class DefaultDataAppConfig: DataAppConfig {
    
    public init() {}
    
    public var appApiBaseUrl: String {
        return "not yet implemented"
    }
}
