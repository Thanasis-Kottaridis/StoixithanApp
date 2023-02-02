//
//  TestState.swift
//  CleanArchitectureTemplate
//
//  Created thanos kottaridis on 2/2/23.
//  Copyright © 2023 . All rights reserved.
//
//

import Foundation
import Domain
import Presentation

class TestState: BaseState {
    
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
    ) -> TestState {
        return TestState(
             isLoading: isLoading ?? self.isLoading,
             isOnline: isOnline ?? self.isOnline
        )
    }
    
    func baseCopy(isLoading: Bool?, isOnline: Bool?) -> Self {
        return self.copy(isLoading: isLoading) as! Self
    }
}
