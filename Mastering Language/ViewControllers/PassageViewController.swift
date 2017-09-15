//
//  PassageViewController.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class PassageViewController: UIViewController {
    
    //Mark:- Properties
    var dataManager: DataManager?
    
    //Mark:- Initialiser
    convenience init(dataManager: DataManager) {
        self.init()
        
        self.dataManager = dataManager
    }
    
    //Mark:- View Life Cycle
    override func viewDidLoad() {
        
    }
}
