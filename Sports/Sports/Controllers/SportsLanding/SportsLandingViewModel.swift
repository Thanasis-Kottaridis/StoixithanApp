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
    
    // MARK: - DI
    @Injected(\.sportsRepository)
    private var sportsRepository: SportsRepository
    
    // MARK: - BaseViewModel Set Up
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
        case .fetchData:
            getSportsWithEvents(forceUpdate: false)
        case .refreshData:
            getSportsWithEvents(forceUpdate: true)
        case .selectFavoriteEvent(let eventId):
            <#code#>
        }
    }
    
    // PRIVATE METHOD IMPLEMENTATION
    private func getSportsWithEvents(forceUpdate: Bool) {
        state.accept(state.value.copy(isLoading: true))
        sportsRepository.getSpotsWithEvents(forceUpdate) { [weak self] result in
            guard let self = self
            else { return }
            
            self.state.accept(self.state.value.copy(isLoading: false))
            
            switch result {
            case .Success(let response):
                print("TestViewModel Debug..... response data \(response?.count)")
            case .Failure(let error):
                self.handleErrors(error: error)
            }
        }
    }
    
    private func selectFavoriteEvent(eventId: String) {
        
    }
}
