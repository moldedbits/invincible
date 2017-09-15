//
//  QuizViewController.swift
//  Mastering Language
//
//  Created by Vaibhav Singh on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import Koloda

class QuizViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var questionLabel: UILabel!

    
    //Mark:- Properties
    var dataManager: DataManager?
    private var passage: Passage?
    var questions = [Question]()

    
    //Mark:- Initialiser
    convenience init(dataManager: DataManager?, passage: Passage) {
        self.init()
        
        self.dataManager = dataManager
        self.passage = passage
        self.questions = passage.question
    }
    
    var selectedPassage: Int = 0
    var selectedQuestion: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        kolodaView.dataSource = self as KolodaViewDataSource
        kolodaView.delegate = self as KolodaViewDelegate
        
        self.updateUI()
    }

    func updateUI() {
        if selectedQuestion < questions.count {
            questionLabel.text = questions[selectedQuestion].text?.spanish
            view.layoutIfNeeded()
        } else {
            

        }
    }

}

extension QuizViewController: KolodaViewDataSource, KolodaViewDelegate {

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let question = questions[index]
        switch question.type ?? .freeText {
        case .freeText:
            let freeTextView = Bundle.main.loadNibNamed(String(describing: SubjectiveQuestionView.self), owner: self, options: nil)?.first as! SubjectiveQuestionView
            return freeTextView
        case .multipleChoice:
            let objectiveQuestionView = Bundle.main.loadNibNamed(String(describing: ObjectiveQuestionView.self), owner: self, options: nil)?.first as! ObjectiveQuestionView
            return objectiveQuestionView
        }
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return questions.count
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return DragSpeed(rawValue: TimeInterval(exactly: 2.0)!)!
    }
}

