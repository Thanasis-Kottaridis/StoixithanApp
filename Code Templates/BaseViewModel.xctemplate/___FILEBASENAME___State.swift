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

   init(
        isLoading: Bool = false
    ) {
        self.isLoading = isLoading
    }
    
    func copy(
       isLoading: Bool? = false
    ) -> ___VARIABLE_moduleName___State {
        return ___VARIABLE_moduleName___State(
             isLoading: isLoading ?? self.isLoading
        )
    }
    
    func baseCopy(
        isLoading: Bool? = nil
    ) -> Self {
        return self.copy(isLoading: isLoading) as! Self
    }
}
