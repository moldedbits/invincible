//
//  TakeQuizViewController.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import XLPagerTabStrip

class TakeQuizViewController: TwitterPagerTabStripViewController {
    
    private var passage: Passage!
    private var dataManager: DataManager?
    
    @IBOutlet weak var submitButton: UIButton!
    
    convenience init(dataManager: DataManager, passage: Passage) {
        self.init()
        
        self.passage = passage
        self.dataManager = dataManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAnswers()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var viewControllers = [UIViewController]()
        for (index, question) in passage.question.enumerated() {
            let viewController = QuestionTableViewController(question: question, questionIndex: index + 1, answer: "")
            viewControllers.append(viewController)
        }
        
        if viewControllers.count == 0 {
            viewControllers.append(EmptyViewController())
            submitButton.isHidden = true
        }
        
        return viewControllers
    }
    
    private func getAnswers() {
        HUD.show(.progress)
        dataManager?.getAnswers(passage: passage)
            .then { answers in
                self.updateUIForAnswers(answers: answers)
            }
            .always {
                HUD.hide()
            }
            .catch { error in
                print(error.localizedDescription)
        }
    }
    
    private func updateUIForAnswers(answers: [Answer]) {
        for controller in viewControllers {
            guard let controller = controller as? QuestionTableViewController else { continue }
            guard let answer = answers.filter({ answer -> Bool in
                guard let answerId = answer.question?.english,
                    let questionId = controller.question.text?.english
                    else { return false }
                
                return answerId == questionId
            }).first else { continue }
            
            controller.setAnswer(answer: answer.answer ?? "")
        }
    }
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        var answers = [[String: Any]]()
        for controller in viewControllers {
            guard let controller = controller as? QuestionTableViewController else { continue }
            let answer: [String: Any] = [
                "question" :
                    [ "english" : controller.question.text?.english ?? "",
                      "spanish" : controller.question.text?.spanish ?? "" ],
                "answer" : controller.answer ?? ""
            ]
            
            answers.append(answer)
        }
        
        submitAnswer(answers: answers)
    }
    
    func submitAnswer(answers: [[String: Any]]) {
        dataManager?.saveAnswers(answer: answers, passage: passage)
            .then { _ -> Void in
                HUD.flash(.success)
                print("answer submited")
                
                return
            }
            .catch { error in
                print(error.localizedDescription)
        }
    }
}
