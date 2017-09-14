//
//  AppCoordinator.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class AppCoordinator: Coordinator {
    
    func start() {
        childCoordinators = []
        //changeViewStateWithUser()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.changeViewStateWithUser()
        }
    }
    
    func changeViewStateWithUser() {
        if let _ = Auth.auth().currentUser {
            startCategoriesCoordinator()
        } else {
            let loginCoordinator = LoginCoordinator(window: window, appCoordinator: self)
            childCoordinators.append(loginCoordinator)
            
            loginCoordinator.start()
        }
    }
    
    func startCategoriesCoordinator() {
        let navigationController = Helper.createNavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        let categoriesCoordinator = CategoriesCoordinator(navController: navigationController, parentCoordinator: self)
        childCoordinators.append(categoriesCoordinator)
        categoriesCoordinator.start()
    }
    
    func loginCoordinatorCompleted(coordinator: LoginCoordinator) {
        removeCoordinator(coordinator)
        startCategoriesCoordinator()
    }
}

final class LoginCoordinator: Coordinator {
    
    var appCoordinator: AppCoordinator?
    
    convenience init(window: UIWindow?, appCoordinator: AppCoordinator) {
        self.init(window: window)
        
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let loginViewController = LoginViewController.init {
            self.stop()
        }
        
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    func stop() {
        appCoordinator?.loginCoordinatorCompleted(coordinator: self)
    }
    
    func logoutUser() {
        appCoordinator?.start()
    }
}

final class CategoriesCoordinator: Coordinator {
    var parentCoordinator: AppCoordinator?
    
    convenience init(navController: UINavigationController, parentCoordinator: AppCoordinator) {
        self.init(navigationController: navController)
        
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let categoriesViewController = CategoriesViewController()
        navigationController?.viewControllers = [categoriesViewController]
    }
}

struct Helper {
    static func createNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.blue
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        return navigationController
    }
}
