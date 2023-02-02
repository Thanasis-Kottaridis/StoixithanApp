//
//  EventMapper.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation
import Domain

struct EventMapper: DomainMapper {
    typealias Model = EventDto
    
    typealias DomainModel = Event
    
    func modelToDomain(model: EventDto) -> Event {
        return Event(
            id: model.id,
            sportId: model.sportId,
            description: model.description,
            timestamp: model.timestamp
        )
    }
    
    func domainToModel(domainModel: Event) -> EventDto {
        return EventDto(
            id: domainModel.id,
            sportId: domainModel.sportId,
            description: domainModel.description,
            timestamp: domainModel.timestamp
        )
    }
}

