//
//  InjectBoundries.swift
//  Data
//
//  Created by thanos kottaridis on 2/2/23.
//

import Foundation
import Domain

private struct DataAppConfigProvider: InjectionKey {
    static var currentValue: DataAppConfig = DefaultDataAppConfig()
}

extension InjectedValues {
    
    public var dataAppConfig: DataAppConfig {
        get { Self[DataAppConfigProvider.self] }
        set { Self[DataAppConfigProvider.self] = newValue }
    }
}
