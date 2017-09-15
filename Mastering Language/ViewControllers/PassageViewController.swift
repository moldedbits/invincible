//
//  PassageViewController.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class PassageViewController: UIViewController {
    
    //Mark:- IBOutlets
    @IBOutlet weak var passageLabel: UILabel!
    
    //Mark:- Properties
    private var dataManager: DataManager?
    private var passage: Passage?
    private var passageTapped: (() -> ())?
    
    //Mark:- Initialiser
    convenience init(dataManager: DataManager?, passage: Passage, passageTapped: @escaping (() -> ())) {
        self.init()
        
        self.passageTapped = passageTapped
        self.dataManager = dataManager
        self.passage = passage
    }
    
    //Mark:- View Life Cycle
    override func viewDidLoad() {
        passageLabel.text = passage?.passageText?.english
    }
}
