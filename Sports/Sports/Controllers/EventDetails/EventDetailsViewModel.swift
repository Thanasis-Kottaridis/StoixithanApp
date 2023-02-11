//
//  EventDetailsViewModel.swift
//  Sports
//
//  Created thanos kottaridis on 12/2/23.
//  Copyright © 2023 . All rights reserved.
//
//

import UIKit
import Domain
import Presentation
import RxSwift
import RxCocoa
import RxDataSources

class EventDetailsViewModel: BaseViewModel {
    
    weak var actionHandler: BaseActionHandler?
    
    typealias State = EventDetailsState
    typealias Event = EventDetailsEvents
    
    let state: BehaviorRelay<State>
    
    var stateObserver: Observable<State> {
        return state.asObservable()
    }
    
    init(eventId: String, actionHandler: BaseActionHandler) {
        self.actionHandler = actionHandler
        state = BehaviorRelay(value: EventDetailsState(eventId: eventId))
        commonInit()
    }
    
    func onTriggeredEvent(event: Event) {
        switch event {
        case .openConnection:
            break
        case .closeConnection:
            break
        }
    }
    
    // PRIVATE METHOD IMPLEMENTATION
}
