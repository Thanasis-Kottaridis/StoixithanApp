//
//  DataBoundry.swift
//  Data
//
//  Created by thanos kottaridis on 2/2/23.
//

import Foundation
import Domain

public class DataBoundry {
    
    // MARK: - Dependencies
    var appConfig: DataAppConfig

    public init(
        appConfig: DataAppConfig
    ) {
        self.appConfig = appConfig
    }
    
    public func initialize() {
        // set up dependencies
        InjectedValues[\.dataAppConfig] = appConfig
    }

}
