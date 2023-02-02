//
//  BaseAppDelegate.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import UIKit

public protocol BaseAppDelegate: AnyObject, UIApplicationDelegate {
    
    associatedtype AppCoordinator: Coordinator
    
    // MARK: - VARS
    var mainCoordinator: AppCoordinator { get set }
    var window: BaseWindow? { get set }
}
