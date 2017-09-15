//
//  QuizViewController.swift
//  Mastering Language
//
//  Created by Vaibhav Singh on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var multipleChoiceContainerView: UIView!
    @IBOutlet weak var freeTextContainerView: UIView!

    @IBAction func sumbitButtonTapped(_ sender: Any) {
    }

    static let dataManger = DataManager()
    var passages = [Passage]()
    var questions = [Question]()

    override func viewDidLoad() {
        super.viewDidLoad()

//        abc.getPassages()
//            .then { categories  in
//                print(categories)
//            }
//            .catch { error in
//                print(error.localizedDescription)
//        }

        QuizViewController.dataManger.getPassages()
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
