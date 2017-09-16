//
//  FreeTextTableViewCell.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class FreeTextTableViewCell: UITableViewCell {

    @IBOutlet weak var answerTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        answerTextView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
}
