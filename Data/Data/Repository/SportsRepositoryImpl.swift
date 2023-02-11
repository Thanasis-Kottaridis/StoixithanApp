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
    @Injected(\.eventDao)
    private var eventDao: EventDao
    private let sessionManager: Session = InjectedValues[\.networkProvider].manager
    
    public init() {}
    
    public func getSpotsWithEvents(
        _ forceUpdate: Bool,
        completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void
    ) {
        /*
         If no force update requires
         and sports exist in local storage.
         fetch local spors and fire completion.
         */
        if !forceUpdate {
            let sports = SportEntityMapper().mapDomainLists(modelList: sportDao.getAllSports())
            if !sports.isEmpty {
                print("💽 💾 💿 Spots fets drom local storage 💽 💾 💿 ")
                completion(Result.Success(sports))
                return
            }
        }
        
        /*
         Else fetch remote spors and fire completion.
         */
        getRemoteSpotsWithEvents(completion: completion)
    }
    
    private func getRemoteSpotsWithEvents(
        completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void
    ) {
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
    
    public func updateFavoriteEvent(byId id: String, isFavorite: Bool) {
        EventDaoImpl().updateFavoriteEvent(byId: id, isFavorite: isFavorite)
    }
}

// MARK: - Helper functions
// TODO: - Remove this.
extension SportsRepositoryImpl {
    public func getAllEvents() -> [Event] {
        let entities = EventDaoImpl().getAllEvents()
        return EventEntityMapper().mapDomainLists(modelList: entities)
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
