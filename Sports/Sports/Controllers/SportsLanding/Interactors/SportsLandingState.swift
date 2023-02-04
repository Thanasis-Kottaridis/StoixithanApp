//
//  SportsLandingState.swift
//  Sports
//
//  Created thanos kottaridis on 4/2/23.
//  Copyright © 2023 . All rights reserved.
//
//

import Foundation
import Domain
import Presentation

class SportsLandingState: BaseState {
    
    // Set variables here
    let isLoading: Bool
    let isOnline: Bool
    let spotrsList: [Sport]
    
    init(
         isLoading: Bool = false,
         isOnline: Bool = true,
         spotrsList: [Sport] = []
     ) {
         self.isLoading = isLoading
         self.isOnline = isOnline
         self.spotrsList = spotrsList
     }
    
    func copy(
        isLoading: Bool? = nil,
        isOnline: Bool? = nil,
        spotrsList: [Sport]? = nil
    ) -> SportsLandingState {
        return SportsLandingState(
            isLoading: isLoading ?? self.isLoading,
            isOnline: isOnline ?? self.isOnline,
            spotrsList: spotrsList ?? self.spotrsList
        )
    }
    
    func baseCopy(
        isLoading: Bool?,
        isOnline: Bool?
    ) -> Self {
        return self.copy(isLoading: isLoading, isOnline: isOnline) as! Self
    }
}
