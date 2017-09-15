//
//  TranslatedTextViewController.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class TranslatedTextViewController: UIViewController {

    @IBOutlet weak var translatedTextLabel: UILabel!
    private var translatedText: String!
    
    convenience init(translatedText: String) {
        self.init()
        
        self.translatedText = translatedText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
