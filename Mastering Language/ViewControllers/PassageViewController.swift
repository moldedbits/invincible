//
//  PassageViewController.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class PassageViewController: UIViewController {
    @IBOutlet weak var passageLabel: UILabel!
    
    private var dataManager: DataManager!
    
    convenience init(dataManager: DataManager) {
        self.init()
        
        self.dataManager = dataManager
    }
    
    override func viewDidLoad() {
        
    }
}
