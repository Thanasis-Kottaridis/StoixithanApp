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
    
    public init() {}
    
    public func getSpotsWithEvents(completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void) {
        AF.request(SportsApi.sportsApi)
            .validateResponseWrapper(
                fromType: [SportDto].self,
                mapperType: [Sport].self,
                mapper: { response in
                    return SportMapper().mapDomainLists(modelList: response)
                },
                completion: completion
            )

    }
}
