//
//  PresentationBoundary.swift
//  Presentation
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation

import Domain

public class PresentationBoundary {
    
    // MARK: - Repository Boundaries
    var sportsRepository: SportsRepository

    public init(
        sportsRepository: SportsRepository
    ) {
        self.sportsRepository = sportsRepository
    }
    
    public func initialize() {
        // set up dependencies
        InjectedValues[\.sportsRepository] = sportsRepository
    }

}
