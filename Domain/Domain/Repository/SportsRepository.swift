//
//  SportsRepository.swift
//  Domain
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation

public protocol SportsRepository {
    
    func getSpotsWithEvents(
        _ forceUpdate: Bool,
        completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void
    )
    
    func updateFavoriteEvent(byId id: String, isFavorite: Bool)
}

extension SportsRepository {
    
    public func getSpotsWithEvents(
        _ forceUpdate: Bool = true,
        completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void
    ) {
        getSpotsWithEvents(forceUpdate, completion: completion)
    }
}

public class DefaultSportsRepository: SportsRepository {

    public init() {}
    
    public func getSpotsWithEvents(
        forceUpdate: Bool,
        completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void
    ) { fatalError("Not Yet Implemented") }
    
    public func updateFavoriteEvent(byId id: String, isFavorite: Bool) {
        fatalError("Not Yet Implemented")
    }
}
