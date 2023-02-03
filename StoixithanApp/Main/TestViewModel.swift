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
import Data
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
//            actionHandler?.handleAction(action: GoToTest())
            testEndpoint()
        }
    }
    
    // PRIVATE METHOD IMPLEMENTATION
    private func testEndpoint() {
        state.accept(state.value.copy(isLoading: true))
        SportsRepositoryImpl().getSpotsWithEvents { [weak self] result in
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
}
