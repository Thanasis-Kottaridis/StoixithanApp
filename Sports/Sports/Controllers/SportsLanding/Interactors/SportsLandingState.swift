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
    var isOnline: Bool
    
    init(
         isLoading: Bool = false,
         isOnline: Bool = true
     ) {
         self.isLoading = isLoading
         self.isOnline = isOnline
     }
    
    func copy(
        isLoading: Bool? = nil,
        isOnline: Bool? = nil
    ) -> SportsLandingState {
        return SportsLandingState(
            isLoading: isLoading ?? self.isLoading,
            isOnline: isOnline ?? self.isOnline
        )
    }
    
    func baseCopy(
        isLoading: Bool?,
        isOnline: Bool?
    ) -> Self {
        return self.copy(isLoading: isLoading, isOnline: isOnline) as! Self
    }
}
