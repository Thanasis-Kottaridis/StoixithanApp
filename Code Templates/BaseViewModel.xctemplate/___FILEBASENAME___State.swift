//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ . All rights reserved.
//
//

import Foundation
import Domain
import Presentation

class ___VARIABLE_moduleName___State: BaseState {
    
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
        sLoading: Bool? = nil,
        isOnline: Bool? = nil
    ) -> ___VARIABLE_moduleName___State {
        return ___VARIABLE_moduleName___State(
            isLoading: isLoading ?? self.isLoading,
            isOnline: isOnline ?? self.isOnline
        )
    }
    
    func baseCopy(
        isLoading: Bool?,
        isOnline: Bool?
    ) -> Self {
        return self.copy(isLoading: isLoading) as! Self
    }
}
