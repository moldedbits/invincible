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
    
    private var dataManager: DataManager?
    private var passage: Passage?
    
    convenience init(dataManager: DataManager?, passage: Passage) {
        self.init()
        
        self.dataManager = dataManager
        self.passage = passage
    }
    
    override func viewDidLoad() {
        
    }
}
