//
//  AllPasagesTableViewCell.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class PassagesTableViewCell: UITableViewCell {

    @IBOutlet weak var passageName: UILabel!
    @IBOutlet weak var passageLines: UILabel!
    
    func configure(with passage: Passage) {
        separatorInset = UIEdgeInsets.zero
        passageName.text = passage.key
        passageLines.text = passage.passageText?.spanish
    }
}
