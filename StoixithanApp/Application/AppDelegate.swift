//
//  AppDelegate.swift
//  CleanArchitectureTemplate
//
//  Created by thanos kottaridis on 28/1/23.
//

import UIKit
import Presentation

@main
class AppDelegate: UIResponder, BaseAppDelegate {
    
    typealias AppCoordinator = MainCoordinator
    
    var window: BaseWindow?
    var mainCoordinator: AppCoordinator
    
    override init() {
        self.window = BaseWindow(frame: UIScreen.main.bounds)
        self.mainCoordinator = MainCoordinator()
        super.init()
    }
        
    /**
     At this point since we use coordinator pattern we have
     to instantiate coordinator in didFinishLaunchingWithOptions
     and to disable Storyboard default launch.
     
     #SOS!!!
     In order to run MainCoordinator successfully we have to go and remove
     main from main interface option in project settings
     
     # UI SCENE DELEGATE
     Check this docimentation in order to add ui scene delegate:
     uiScene doc: https://medium.com/@kalyan.parise/understanding-scene-delegate-app-delegate-7503d48c5445
     and this tutorial for coordinators with UIScene:
     https://www.youtube.com/watch?v=SAZzcKvOvAE
     */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // create a base UIWindow and activate it
        window?.backgroundColor = .white
        window?.rootViewController = mainCoordinator.navigationController
        window?.makeKeyAndVisible()
        
        // start main coordinator
        mainCoordinator.start()
        return true
    }
}

