//
//  QuestionTableViewController.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class QuestionTableViewController: UITableViewController {
    
    private var question: Question!
    private var questionIndex: Int = 0
    private var selectedOptionIndex: Int?
    
    convenience init(question: Question, questionIndex: Int, selectedOptionIndex: Int? = nil) {
        self.init()
        
        self.question = question
        self.questionIndex = questionIndex
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView() {
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(QuestionTableViewCell.nib(), forCellReuseIdentifier: String(describing: QuestionTableViewCell.self))
        tableView.register(FreeTextTableViewCell.nib(), forCellReuseIdentifier: String(describing: FreeTextTableViewCell.self))
        tableView.register(OptionTableViewCell.nib(), forCellReuseIdentifier: String(describing: OptionTableViewCell.self))
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch question?.type ?? .freeText {
        case .freeText:
            return 2
        case .multipleChoice:
            return (question?.options.count ?? 0) + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuestionTableViewCell.self), for: indexPath) as! QuestionTableViewCell
            cell.configure(question: question)
            
            return cell
        }
        
        switch question?.type ?? .freeText {
        case .freeText:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FreeTextTableViewCell.self), for: indexPath) as! FreeTextTableViewCell
            
            return cell
        case .multipleChoice:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OptionTableViewCell.self), for: indexPath) as! OptionTableViewCell
            
            let option = question.options[indexPath.row - 1]
            var isSelected = false
            if let selectedOption = selectedOptionIndex, (indexPath.row - 1) == selectedOption {
                isSelected = true
            }
            
            cell.configure(optionText: option, isSelected: isSelected)
            
            return cell
        }
    }
}

extension QuestionTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Question \(questionIndex)")
    }
}
