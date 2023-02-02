//
//  DomainMapper.swift
//  iOSGovWallet
//
//  Created by thanos kottaridis on 7/3/22.
//
import Foundation

/**
 * Every Mapper object has to implement DomainMapper interface in order to provide 4 methods
 * - modelToDomain: converts target model to domain model
 * - domainToDto: converts domain model to target model
 * - mapModelLists: this method has a default implementation and is used in order to map list of domain model objects into target model lists
 * - mapDomainLists: this method has a default implementation and is used in order to map list of target model objects into domain model lists
 */
protocol DomainMapper {
    associatedtype Model: Codable
    associatedtype DomainModel: Codable
        
    func modelToDomain(model: Model) -> DomainModel
    
    func domainToModel(domainModel: DomainModel) -> Model
    
    func mapModelLists(domainList: [DomainModel]) -> [Model]
    
    func mapDomainLists(modelList: [Model]) -> [DomainModel]
}

extension DomainMapper {
    func mapModelLists(domainList: [DomainModel]) -> [Model] {
        return domainList.map {
            domainToModel(domainModel: $0)
        }
    }
    
    func mapDomainLists(modelList: [Model]) -> [DomainModel] {
        return modelList.map {
            modelToDomain(model: $0)
        }
    }
}
