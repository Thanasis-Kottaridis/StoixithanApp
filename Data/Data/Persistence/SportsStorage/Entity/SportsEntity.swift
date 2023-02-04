//
//  Sports.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation
import RealmSwift
import Domain

class SportEntity: Object, Codable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var sportDescription: String = ""
    @Persisted var events: List<EventEntity>
}

class EventEntity: Object, Codable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var sportId: String = ""
    @Persisted var eventDescription: String = ""
    @Persisted var timestamp: Int = 1
    @Persisted var isFavorite: Bool = false
}

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

struct EventEntityMapper: DomainMapper {
    typealias Model = EventEntity
    
    typealias DomainModel = Event
    
    func modelToDomain(model: EventEntity) -> Event {
        return Event(
            id: model.id,
            sportId: model.sportId,
            description: model.eventDescription,
            timestamp: model.timestamp,
            isFavorite: model.isFavorite
        )
    }
    
    func domainToModel(domainModel: Event) -> EventEntity {
        let entity = EventEntity()
        
        entity.id = domainModel.id ?? ""
        entity.sportId = domainModel.sportId ?? ""
        entity.eventDescription = domainModel.description ?? ""
        entity.timestamp = domainModel.timestamp ?? 1
        entity.isFavorite = domainModel.isFavorite
        
        return entity
    }
}
