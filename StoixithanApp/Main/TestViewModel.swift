//
//  TestViewModel.swift
//  CleanArchitectureTemplate
//
//  Created thanos kottaridis on 2/2/23.
//  Copyright © 2023 . All rights reserved.
//
//

import UIKit
import Domain
import Presentation
import RxSwift
import RxCocoa
import RxDataSources

class TestViewModel: BaseViewModel {
    weak var actionHandler: Presentation.BaseActionHandler?
    
    typealias State = TestState
    typealias Event = TestEvents
    
    let state: BehaviorRelay<State>
    
    var stateObserver: Observable<State> {
        return state.asObservable()
    }
    
    init(actionHandler: BaseActionHandler) {
        self.actionHandler = actionHandler
        state = BehaviorRelay(value: TestState())
        commonInit()
    }
    
    func onTriggeredEvent(event: Event) {
        switch event {
            // Event case go here
        case .goToTest:
            actionHandler?.handleAction(action: GoToTest())
        }
    }
    
    // PRIVATE METHOD IMPLEMENTATION
}
