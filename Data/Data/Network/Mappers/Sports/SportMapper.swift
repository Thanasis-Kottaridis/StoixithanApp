//
//  SportMapper.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation
import Domain

struct SportMapper: DomainMapper {
    typealias Model = SportDto
    
    typealias DomainModel = Sport
    
    func modelToDomain(model: SportDto) -> Sport {
        return Sport(
            id: model.id,
            description: model.description,
            events: EventMapper().mapDomainLists(modelList: model.events ?? [])
        )
    }
    
    func domainToModel(domainModel: Sport) -> SportDto {
        return SportDto(
            id: domainModel.id,
            description: domainModel.description,
            events: EventMapper().mapModelLists(domainList: domainModel.events ?? [])
        )
    }
    
}
