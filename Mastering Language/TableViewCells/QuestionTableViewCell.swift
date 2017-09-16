//
//  QuestionTableViewCell.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import EasyTipView

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textTapped))
            questionLabel.addGestureRecognizer(tapGestureRecognizer)
            tapGestureRecognizer.isEnabled = true
            
            questionLabel.isUserInteractionEnabled = true
        }
    }
    
    private var tipView: EasyTipView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(question: Question) {
        self.questionLabel.text = question.text?.spanish ?? ""
        self.tipView = EasyTipView(text: question.text?.english ?? "")
    }
    
    @objc private func textTapped() {
        tipView?.show(animated: true, forView: questionLabel, withinSuperview: contentView)
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        super.endEditing(force)
        
        tipView?.dismiss()
        
        return true
    }
    
}
