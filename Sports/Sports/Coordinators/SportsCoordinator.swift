//
//  SportsCoordinator.swift
//  Sports
//
//  Created by thanos kottaridis on 4/2/23.
//

import UIKit
import Presentation

struct GoToSportsLanding: Action {}

public class SportsCoordinator: Coordinator {
    public weak var parentCoordinator: Presentation.Coordinator?
    public var childCoordinators: [Presentation.CoordinatorKey : Presentation.Coordinator] = [:]
    public var navigationController: UINavigationController
    public let coordinatorKey: Presentation.CoordinatorKey = .sportsCoordinator
    
    // MARK: - INIT
    //Inject main navigation Controller
    public init(
        navigationController: UINavigationController? = nil,
        parentCoordinator: Coordinator,
        doStart: Bool = true
    ) {
        // no parent coordinator for this coord
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController ?? UINavigationController()
        
        if doStart {
            start()
        }
    }
    
    public func start() {
        handleAction(action: GoToSportsLanding())
    }
}

// MARK: - Handle Actions
extension SportsCoordinator {
    public func handleAction(action: Action) {
        switch action {
        case _ as GoToSportsLanding:
            let viewModel = SportsLandingViewModel(actionHandler: self)
            let vc = SportsLandingVC(viewModel: viewModel)
            navigate(to: vc, with: .push)
            handleAction(action: ShowLoaderAction())
        default:
            // Use super implementation of BaseActionHandler
            handleBaseAction(action: action)
        }
    }
}
