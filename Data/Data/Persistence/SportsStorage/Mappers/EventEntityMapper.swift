//
//  EventEntityMapper.swift
//  Data
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation
import RealmSwift
import Domain

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
