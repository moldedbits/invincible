//
//  TakeQuizViewController.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TakeQuizViewController: TwitterPagerTabStripViewController {
    
    private var passage: Passage!
    
    convenience init(passage: Passage) {
        self.init()
        
        self.passage = passage
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var viewControllers = [UIViewController]()
        for (index, question) in passage.question.enumerated() {
            let viewController = QuestionTableViewController(question: question, questionIndex: index)
            viewControllers.append(viewController)
        }
        
        if viewControllers.count == 0 {
            viewControllers.append(EmptyViewController())
        }
        
        return viewControllers
    }
}
