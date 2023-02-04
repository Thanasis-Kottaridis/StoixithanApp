//
//  SportsRepositoryImpl.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation
import Domain
import Alamofire

public class SportsRepositoryImpl: SportsRepository {
    
    @Injected(\.sportDao)
    private var sportDao: SportDao
    private let sessionManager: Session = InjectedValues[\.networkProvider].manager
    
    public init() {}
    
    public func getSpotsWithEvents(completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void) {
        sessionManager.request(SportsApi.sportsApi)
            .validateResponseWrapper(
                fromType: [SportDto].self,
                mapperType: [Sport].self,
                mapper: { response in
                    return SportMapper().mapDomainLists(modelList: response)
                },
                cacheLocaly: { sports in
                    
                    guard let sports = sports
                    else { return }
                    
                    // clear sports and events
                    let dao = SportDaoImpl()
                    dao.deleteAllDocuments()
                    dao.storeSports(
                        sports: SportEntityMapper().mapModelLists(domainList: sports)
                    )
                },
                completion: completion
            )
    }
    
    public func getAllEvents() -> [Event] {
        let entities = EventDaoImpl().getAllEvents()
        return EventEntityMapper().mapDomainLists(modelList: entities)
    }
    
    public func updateFavoriteEvent(byId id: String, isFavorite: Bool) {
        EventDaoImpl().updateFavoriteEvent(byId: id, isFavorite: isFavorite)
    }
    
    public func getEvent(byId id: String) -> Event {
        return  EventEntityMapper().modelToDomain(
            model: EventDaoImpl().getEvent(byId: id) ?? EventEntity()
        )
    }
    
    public func getSport(byId id: String) -> Sport {
        return SportEntityMapper().modelToDomain(
            model: SportDaoImpl().getSport(byId: id) ?? SportEntity()
        )
    }
}
