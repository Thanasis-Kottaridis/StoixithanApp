//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ . All rights reserved.
//
//

import UIKit
import Domain
import Presentation
import RxSwift
import RxCocoa
import RxDataSources

class ___VARIABLE_moduleName___ViewModel: BaseViewModel, ___VARIABLE_actionDispatcherName___ActionDispatcher {
    
    weak var actionHandler: ___VARIABLE_actionHandlerName___ActionHandler?
    
    typealias State = ___VARIABLE_moduleName___State
    typealias Event = ___VARIABLE_moduleName___Events
    
    let state: BehaviorRelay<State>
    
    var stateObserver: Observable<State> {
        return state.asObservable()
    }
    
    init(actionHandler: ___VARIABLE_actionHandlerName___ActionHandler) {
        self.actionHandler = actionHandler
        state = BehaviorRelay(value: ___VARIABLE_moduleName___State())
        commonInit()
    }
    
    func onTriggeredEvent(event: Event) {
        switch event {
            // Event case go here
        }
    }
    
    // PRIVATE METHOD IMPLEMENTATION
}
