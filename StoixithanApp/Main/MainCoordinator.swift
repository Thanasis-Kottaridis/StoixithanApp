//
//  MainCoordinator.swift
//  CleanArchitectureTemplate
//
//  Created by thanos kottaridis on 29/1/23.
//

import UIKit
import Domain
import Presentation

struct GoToTest: Action {}

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
        handleAction(action: GoToTest())
        handleAction(action: ShowLoaderAction())

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.handleAction(action: HideLoaderAction())
            self.handleAction(action: PresentFeedbackAction(feedbackMessage: FeedbackMessage(message: "Message Works", type: .success)))
        }
    }
}

extension MainCoordinator {
    func handleAction(action: Action) {
        switch action {
        case _ as GoToTest:
            let viewModel = TestViewModel(actionHandler: self)
            let vc = TestVC(viewModel: viewModel)
            navigate(to: vc, with: .push)
            handleAction(action: ShowLoaderAction())
        default:
            // Use super implementation of BaseActionHandler
            handleBaseAction(action: action)
        }
    }
}
