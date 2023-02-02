//
//  Coordinator.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import UIKit

public enum NavigationStyle {
    case present
    case push
    case resetStack
    case bottomSheet
    case overCurrentContext
    case overFullScreen
    case pop
    case reversePush
    case fade
}

public protocol Coordinator: AnyObject, BaseActionHandler {
    // MARK: - Vars
    var parentCoordinator: Coordinator? {get set}
    var childCoordinators: [CoordinatorKey: Coordinator] { get set }
    var navigationController: UINavigationController {get set}
    var coordinatorKey: CoordinatorKey { get }
    
    // MARK: - Funcs
    func start()
    func stop(completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func addChild(coordinator: Coordinator, with key: CoordinatorKey)
    func removeChild(coordinator: Coordinator)
    func removeChild(key: CoordinatorKey)
}

// MARK: Default Implementations.
extension Coordinator {
    
    public func addChild(
        coordinator: Coordinator,
        with key: CoordinatorKey
    ) {
        childCoordinators[key] = coordinator
    }
    
    public func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.value !== coordinator
        }
    }
    
    public func removeChild(key: CoordinatorKey) {
        if let coord = childCoordinators[key] {
            removeChild(coordinator: coord)
            print("Coordinator with key: \(key) removed")
        }
    }
    
    public func getCoordingator(_ key: CoordinatorKey) -> Coordinator? {
        return childCoordinators[key]
    }
    
    public func stop(completion: (() -> Void)? = nil) {
        self.parentCoordinator?.removeChild(coordinator: self)
        completion?()
    }
    
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }
            self.stop(completion: completion)
        }
    }
}

// MARK: - Navigation EXT
extension Coordinator {
    public func navigate(
        to viewController: UIViewController,
        with navigationStyle: NavigationStyle,
        animated: Bool = true,
        resetingStack: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        switch navigationStyle {
        case .push:
            navigationController.pushViewController(viewController, animated: animated)
        case .present:
            viewController.modalPresentationStyle = .fullScreen
            viewController.definesPresentationContext = true
            navigationController.present(viewController, animated: animated, completion: completion)
        case .resetStack:
            break
        case .bottomSheet:
            // TODO: - Add Bottomsheet Navigation Here
            break
        case .overCurrentContext:
            viewController.modalPresentationStyle = .overCurrentContext
            navigationController.present(viewController, animated: animated, completion: completion)
        case .overFullScreen:
            viewController.modalPresentationStyle = .overFullScreen
            navigationController.present(viewController, animated: animated, completion: completion)
        case .pop:
            navigationController.popViewController(animated: animated)
        case .reversePush:
            navigationController.addTransition()
            navigationController.pushViewController(viewController, animated: false)
        case .fade:
            navigationController.addTransition(transitionType: .fade)
            navigationController.pushViewController(viewController, animated: false)
        }
    }
}
