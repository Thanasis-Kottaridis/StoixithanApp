//
//  InjectRepositories.swift
//  Presentation
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation
import Domain

private struct SportsRepositoryProvider: InjectionKey {
    static var currentValue: SportsRepository = Domain.DefaultSportsRepository()
}

extension InjectedValues {
    
    public var sportsRepository: SportsRepository {
        get { Self[SportsRepositoryProvider.self] }
        set { Self[SportsRepositoryProvider.self] = newValue }
    }
}
