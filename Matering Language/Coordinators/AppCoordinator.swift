//
//  AppCoordinator.swift
//  Matering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    func start() {
        childCoordinators = []
        if UserDefaults.standard.getCurrentUserAuthToken() != nil {
            startTabCoordinator()
        } else {
            let loginCoordinator = LoginCoordinator(window: window, appCoordinator: self)
            childCoordinators.append(loginCoordinator)
            
            loginCoordinator.start()
        }
    }
    
    func startTabCoordinator() {
        let tabbarCoordinator = TabbarCoordinator(window: window, appCoordinator: self)
        childCoordinators.append(tabbarCoordinator)
        tabbarCoordinator.start()
    }
    
    func loginCoordinatorCompleted(coordinator: LoginCoordinator) {
        removeCoordinator(coordinator)
        startTabCoordinator()
    }
}

final class LoginCoordinator: Coordinator {
    
    var appCoordinator: AppCoordinator?
    
    convenience init(window: UIWindow?, appCoordinator: AppCoordinator) {
        self.init(window: window)
        
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let loginViewController = LogInViewController.init() {
            self.stop()
        }
        
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    func stop() {
        appCoordinator?.loginCoordinatorCompleted(coordinator: self)
    }
}

final class TabbarCoordinator: Coordinator {
    var appCoordinator: AppCoordinator?
    
    convenience init(window: UIWindow?, appCoordinator: AppCoordinator) {
        self.init(window: window)
        
        self.appCoordinator = appCoordinator
    }
    
    func start() {
//        let tabbarController = TabBarController()
//        let dashboardTab = TabbarCoordinator.createNavigationController()
//        let dashboardCoordinator = DashboardCoordinator(navigationController: dashboardTab, parentCoordinator: self, context: context)
//        dashboardCoordinator.start()
//
//        let profileTab = TabbarCoordinator.createNavigationController()
//        let profileCoordinator = ProfileCoordinator(navigationController: profileTab, parentCoordinator: self, context: context)
//        profileCoordinator.start()
//
//        childCoordinators.append(contentsOf: [dashboardCoordinator, employeeDirectoryCoordinator, timesheetCoordinator, holidaysCoordinator, profileCoordinator])
//
//        tabbarController.viewControllers = [dashboardTab, employeeDirectoryTab, timesheetTab, holidaysTab, profileTab]
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
    }
    
    static func createNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().barTintColor = ColorHex.multipleUtility.color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        return navigationController
    }
    
    func logoutUser() {
        appCoordinator?.start()
    }
}


