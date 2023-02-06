//
//  BaseViewModel.swift
//  Presentation
//
//  Created by thanos kottaridis on 1/2/23.
//

import Foundation
import Network
import Domain
import RxSwift
import RxCocoa

// MARK: - Base Error Handler
/**
 This Protocol Has a default implementation on handleErrors Method.
 Handle errors method is used to handle all common errors that can be occured on any flow
 For example:
 - 401 for unauthorized
 - (-1100)..<(-1000): For Alamofire no internet Response
 
 It is also capable of handling all known buisness errors from `BaseException.exception` provided from Back End.
 */
public protocol BaseErrorHandler: AnyObject, BaseActionDispatcher {
    
    /**
     Handle Errors methos takes a BaseException error and displays the respective message / view to user.
     - Parameter error: Base excatpion error.
     - Parameter withDefaultHandling: This parameter indicates wether to show default mesage if an unhandled case occoured or not.
     - Returns: A Bool that shows if the error case handled or not.
     */
    @discardableResult
    func handleErrors(error: BaseException, withDefaultHandling: Bool) -> Bool
    
    func ensureMainThread(_ block:  @escaping () -> Void)
}

extension BaseErrorHandler {
    @discardableResult
    public func handleErrors(error: BaseException, withDefaultHandling: Bool = true) -> Bool {
        
        // handle error
        let genericErrorMessage = Str.SOMETHING_WENT_WRONG
        var feedback: FeedbackMessage? = nil
        
        if let throwable = error.throwable {
            feedback = FeedbackMessage(
                message: throwable.localizedDescription,
                type: .error
            )
        } else if error.errorCode == 401 {
            feedback = FeedbackMessage(
                message: Str.LOGIN_SESSION_INVALIDATED,
                type: .error
            )
        } else if ((-1100)..<(-1000)).contains(error.errorCode) {
            feedback = FeedbackMessage.getNetworkFeedbackMessage(isOnline: false)
        } else if withDefaultHandling {
            feedback = FeedbackMessage(
                message: Str.NETWORK_ERROR_TITLE,
                type: .error
            )
        }
        
        if let feedback = feedback {
            actionHandler?.handleAction(action: PresentFeedbackAction(feedbackMessage: feedback))
            return true
        } else {
            return false
        }
    }
    
    public func ensureMainThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}

// MARK: - Base View Model
public protocol BaseViewModel: ReactiveCompatible, BaseErrorHandler {
    associatedtype State: BaseState
    associatedtype Event
    
    var state: BehaviorRelay<State> { get }
    var stateObserver: Observable<State> { get }
    
    func commonInit()
    func onTriggeredEvent(event: Event)
}

extension BaseViewModel {
    
    public func commonInit() {
        setUpNetworkMonitor()
        setUpLoadingObserver()
        setUpConnectivityObserver()
    }
    
    private func setUpNetworkMonitor() {
        
        let monitor: NWPathMonitor = NWPathMonitor()
            
        monitor.pathUpdateHandler = { [weak self] path in
            
            guard let self = self else {
                return
            }
            
            if path.status == .satisfied {
                print("Connectivite Observer...... \(String(describing: Self.self)) 📶 📶 📶 We're connected!")
        
            } else {
                print("Connectivite Observer...... \(String(describing: Self.self)) 📶 📶 📶 No connection.")
            }

            self.state.accept(self.state.value.baseCopy(
                isLoading: false,
                isOnline: path.status == .satisfied
            ))
            
            print(path.isExpensive)
        }
        
        print("Connectivite Observer...... \(String(describing: Self.self)) 📶 📶 📶 set up queue.")
       

        
        let queue = DispatchQueue(
            label: "Monitor+\(String(describing: Self.self))"
        )
        monitor.start(queue: queue)
    }
    
    private func setUpLoadingObserver() {
        stateObserver.observe(on: MainScheduler.instance) /// observe on mainThread coz we update UI
            .map{ $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.actionHandler?.handleAction(action: ShowLoaderAction())
                } else {
                    self?.actionHandler?.handleAction(action: HideLoaderAction())
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func setUpConnectivityObserver() {
        Observable.zip(stateObserver, stateObserver.skip(1))
            .map { (oldState, newState) in
                return (newState.isOnline, oldState.isOnline)
            }
            .subscribe { (newIsOnline, oldIsOnline) in
                if newIsOnline != oldIsOnline, !oldIsOnline {
                    self.actionHandler?.handleAction(action: PresentFeedbackAction(
                        feedbackMessage: FeedbackMessage.getNetworkFeedbackMessage(isOnline: true)
                    )
                    )
                    
                } else if !newIsOnline, newIsOnline != oldIsOnline {
                    self.actionHandler?.handleAction(action: PresentFeedbackAction(
                        feedbackMessage: FeedbackMessage.getNetworkFeedbackMessage(isOnline: false)
                    )
                    )
                }
            }.disposed(by: rx.disposeBag)
    }
}
