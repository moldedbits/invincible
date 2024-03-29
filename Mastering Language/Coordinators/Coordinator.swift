//
//  Coordinator.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    
    //Mark:- Properties
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    weak var window: UIWindow?
    var dataManager: DataManager?
    
    //Mark:- Initialiser
    init(window: UIWindow? = nil, navigationController: UINavigationController? = nil, dataManager: DataManager? = nil) {
        self.window = window
        self.navigationController = navigationController
        self.dataManager = dataManager        
    }
    
    //Mark:- Function
    func removeCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.index(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
