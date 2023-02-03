//
//  SportsRepository.swift
//  Domain
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation

public protocol SportsRepository {
    
    func getSpotsWithEvents(completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void)
}
