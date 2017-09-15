//
//  QuizViewController.swift
//  Mastering Language
//
//  Created by Vaibhav Singh on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    //Mark:- IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var multipleChoiceContainerView: UIView!
    @IBOutlet weak var freeTextContainerView: UIView!

    @IBAction func sumbitButtonTapped(_ sender: Any) {
    }
    
    //Mark:- Properties
    var dataManager: DataManager?
    var passages = [Passage]()
    var questions = [Question]()
    
    //Mark:- Initialiser
    convenience init(dataManager: DataManager?) {
        self.init()
        
        self.dataManager = dataManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataManager?.getPassages()
            .then { passages -> Void in
                self.questions = passages[0].question
                self.updateUI()
        }
            .catch { error in
                print(error.localizedDescription)
        }
    }

    func updateUI() {
        if let question = questions.first as Question? {
            questionLabel.text = question.text?.english
        }

    }

}
