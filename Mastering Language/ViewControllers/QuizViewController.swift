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

    //    @IBAction func sumbitButtonTapped(_ sender: Any) {
    //        if selectedQuestion < questions.count {
    //            selectedQuestion += 1
    //        }
    //        updateUI()
    //    }

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

        kolodaView.dataSource = self as KolodaViewDataSource
        kolodaView.delegate = self as KolodaViewDelegate

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

extension QuizViewController: KolodaViewDataSource, KolodaViewDelegate {

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
//        if index.quotientAndRemainder(dividingBy: 2).remainder == 0 {
//            let v2 = Bundle.main.loadNibNamed(String(describing: ObjectiveQuestionView.self), owner: self, options: nil)?.first as! ObjectiveQuestionView
//            return v2
//        } else {
//            let v2 = Bundle.main.loadNibNamed(String(describing: SubjectQuestionView.self), owner: self, options: nil)?.first as! SubjectQuestionView
//            return v2
//        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
        view.backgroundColor = UIColor.white
        return view
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 5
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return DragSpeed(rawValue: TimeInterval(exactly: 2.0)!)!
    }


}

