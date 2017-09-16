//
//  OptionTableViewCell.swift
//  Mastering Language
//
//  Created by Amit Kumar Swami on 16/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionAnswerLabel: UILabel!
    @IBOutlet weak var optionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(optionText: String, isSelected: Bool) {
        optionAnswerLabel.text = optionText
        optionImageView.isHidden = !isSelected
    }
}
