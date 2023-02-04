//
//  MainCoordinator.swift
//  CleanArchitectureTemplate
//
//  Created by thanos kottaridis on 29/1/23.
//

import UIKit
import Domain
import Presentation
import Sports

struct GoToTest: Action {}
struct GoToSports: Action {}

class MainCoordinator: Coordinator {
    var parentCoordinator: Presentation.Coordinator?
    var childCoordinators = [Presentation.CoordinatorKey : Presentation.Coordinator]()
    var navigationController: UINavigationController
    var coordinatorKey: CoordinatorKey = .mainCoordinator
    
    // MARK: - INIT
    //Inject main navigation Controller
    init(navigationController: UINavigationController? = nil) {
        // no parent coordinator for this coord
        parentCoordinator = nil
        self.navigationController = navigationController ?? UINavigationController()
    }
    
    func start() {
        handleAction(action: GoToSports())
    }
}

extension MainCoordinator {
    func handleAction(action: Action) {
        switch action {
        case _ as GoToSports:
            let sportsCoord = SportsCoordinator(
                navigationController: self.navigationController,
                parentCoordinator: self
            )
            self.addChild(coordinator: sportsCoord, with: .sportsCoordinator)
        case _ as GoToTest:
            let viewModel = TestViewModel(actionHandler: self)
            let vc = TestVC(viewModel: viewModel)
            navigate(to: vc, with: .push)
        default:
            // Use super implementation of BaseActionHandler
            handleBaseAction(action: action)
        }
    }
}
