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
    @IBOutlet weak var submitButton: UIButton!

    @IBAction func sumbitButtonTapped(_ sender: Any) {
        if selectedQuestion < questions.count {
            selectedQuestion += 1
        }
        updateUI()
    }

    static let dataManger = DataManager()
    var passages = [Passage]()
    var questions = [Question]()
    var selectedPassage: Int = 0
    var selectedQuestion: Int = 0

    //Todo: After Database correction
//        lazy var quizPassage = Passage()
    //    init(questionsFrom selectedPassage: Passage) {
    //        quizPassage = selectedPassage
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()

        QuizViewController.dataManger.getPassages()
            .then { passages -> Void in
                for count in 0...passages.count - 1 {
                    if passages[count].question.count > 0 {
                        self.questions = passages[count].question
                        self.selectedPassage = count
                        self.updateUI()
                        print(self.questions.count)
                        break
                    }
                }
            }
            .catch { error in
                print(error.localizedDescription)
        }
    }

    func updateUI() {
        if selectedQuestion < questions.count {
            questionLabel.text = questions[selectedQuestion].text?.spanish
            view.layoutIfNeeded()
        } else {
            

        }
    }

}
