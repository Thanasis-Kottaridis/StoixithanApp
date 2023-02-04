//
//  InjectDependencies.swift
//  Data
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation
import Domain

/**
 We create a NetworkProviderKey class that is responsible for instantiating NetworkProvider Key
 and conforms Injection Key protocol
 */
private struct NetworkProviderKey: InjectionKey {
    static var currentValue: NetworkProvider = NetworkProviderImpl()
}

private struct SportDaoProvider: InjectionKey {
    static var currentValue: SportDao = SportDaoImpl()
}

private struct EventDaoProvider: InjectionKey {
    static var currentValue: EventDao = EventDaoImpl()
}

/**
 For every Injected Value we have to create a computed property of its Provider in order to have access on it via get and set methods
 **Self:** Here referring to the working Extension of `InjectedValues`
 **Provider.self:** here provides Provider type (that conforms InjectionKey) to InjectedValues key subscript.
 */
extension InjectedValues {
    
    var networkProvider: NetworkProvider {
        get { Self[NetworkProviderKey.self]}
        set { Self[NetworkProviderKey.self] = newValue }
    }

    var sportDao: SportDao {
        get { Self[SportDaoProvider.self] }
        set { Self[SportDaoProvider.self] = newValue }
    }
    
    var eventDao: EventDao {
        get { Self[EventDaoProvider.self] }
        set { Self[EventDaoProvider.self] = newValue }
    }
}
