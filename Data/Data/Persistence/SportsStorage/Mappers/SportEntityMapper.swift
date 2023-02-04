//
//  SportEntityMapper.swift
//  Data
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation
import RealmSwift
import Domain

struct SportEntityMapper: DomainMapper {
    typealias Model = SportEntity
    
    typealias DomainModel = Sport
    
    func modelToDomain(model: SportEntity) -> Sport {
        
        // map all fields
        let events = EventEntityMapper()
            .mapDomainLists(modelList: Array(model.events))
        
        return Sport(
            id: model.id,
            description: model.sportDescription,
            events: events
        )
    }
    
    
    func modelToDomain(model: [SportEntity]) -> [Sport] {
        
        return model.map { entity in
            let events = EventEntityMapper()
                .mapDomainLists(modelList: Array(entity.events))
            
            return Sport(
                id: entity.id,
                description: entity.sportDescription,
                events: events
            )
        }
    }
    
    func domainToModel(domainModel: Sport) -> SportEntity {
        let entity = SportEntity()
        
        entity.id = domainModel.id ?? ""
        entity.sportDescription = domainModel.description ?? ""
        entity.events.append(
            objectsIn: EventEntityMapper().mapModelLists(domainList: domainModel.events ?? []
        ))
        
        return entity
    }
    
}
