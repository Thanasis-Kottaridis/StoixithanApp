//
//  InjectDependencies.swift
//  Data
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation
import Domain

private struct SportDaoProvider: InjectionKey {
    static var currentValue: SportDao = SportDaoImpl()
}

private struct EventDaoProvider: InjectionKey {
    static var currentValue: EventDao = EventDaoImpl()
}

extension InjectedValues {
    
    var sportDao: SportDao {
        get { Self[SportDaoProvider.self] }
        set { Self[SportDaoProvider.self] = newValue }
    }
    
    var eventDao: EventDao {
        get { Self[EventDaoProvider.self] }
        set { Self[EventDaoProvider.self] = newValue }
    }
}
