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
        dataManager = DataManager()
        childCoordinators = []
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
        let categoriesCoordinator = CategoriesCoordinator(navController: navigationController, parentCoordinator: self, dataManager: dataManager)
        
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
    
    convenience init(navController: UINavigationController, parentCoordinator: AppCoordinator, dataManager: DataManager?) {
        self.init(navigationController: navController, dataManager: dataManager)
        
        self.parentCoordinator = parentCoordinator
        
    }
    
    func start() {
        let categoriesViewController = CategoriesViewController.init(dataManager: dataManager) { category in
            self.stop(selectedCategory: category)
        }
        navigationController?.viewControllers = [categoriesViewController]
    }
    
    func stop(selectedCategory: Category) {
        let passageCoordinator = PassageCoordinator(navController: navigationController, parentCoordinator: parentCoordinator, dataManager: dataManager, passage: selectedCategory.passages.first)
        childCoordinators.append(contentsOf: [passageCoordinator])
        passageCoordinator.start()
    }
}

final class PassageCoordinator: Coordinator {
    var parentCoordinator: AppCoordinator?
    var passage: Passage?
    
    convenience init(navController: UINavigationController?, parentCoordinator: AppCoordinator?, dataManager: DataManager?, passage: Passage?) {
        self.init(navigationController: navController, dataManager: dataManager)
        
        self.parentCoordinator = parentCoordinator
        self.passage = passage
    }
    
    func start() {
        guard let dataManager = dataManager,
            let passage = passage
            else { return }
        let passageViewController = PassageViewController(dataManager: dataManager, passage: passage)
        navigationController?.pushViewController(passageViewController, animated: true)
    }
    
    func stop() {
        
    }
}


struct Helper {
    static func createNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.lightGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        return navigationController
    }
}

final class QuizCoordinator: Coordinator {
    var parentCoordinator: AppCoordinator?
    
    convenience init(navController: UINavigationController?, parentCoordinator: AppCoordinator?, dataManager: DataManager?) {
        self.init(navigationController: navController, dataManager: dataManager)
        
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        
    }
}
