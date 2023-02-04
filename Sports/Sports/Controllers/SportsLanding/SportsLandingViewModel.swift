//
//  SportsLandingViewModel.swift
//  Sports
//
//  Created thanos kottaridis on 4/2/23.
//  Copyright © 2023 . All rights reserved.
//
//

import UIKit
import Domain
import Presentation
import RxSwift
import RxCocoa
import RxDataSources

class SportsLandingViewModel: BaseViewModel {
    
    weak var actionHandler: BaseActionHandler?
    
    typealias State = SportsLandingState
    typealias Event = SportsLandingEvents
    
    let state: BehaviorRelay<State>
    
    var stateObserver: Observable<State> {
        return state.asObservable()
    }
    
    init(actionHandler: BaseActionHandler) {
        self.actionHandler = actionHandler
        state = BehaviorRelay(value: SportsLandingState())
        commonInit()
    }
    
    func onTriggeredEvent(event: Event) {
        switch event {
            // Event case go here
        }
    }
    
    // PRIVATE METHOD IMPLEMENTATION
}
