//
//  AllPasagesTableViewCell.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class PassagesTableViewCell: UITableViewCell {

    @IBOutlet weak var difficultyLevel: UILabel!
    @IBOutlet weak var passageName: UILabel!
    @IBOutlet weak var passageLines: UILabel!
    
    func configure(with passage: Passage) {
        separatorInset = UIEdgeInsets.zero
        guard let passageDifficultyLevel = passage.difficulty else { return }
        difficultyLevel.text = "For \(passageDifficultyLevel)"
        passageName.text = passage.key
        passageLines.text = passage.passageText?.spanish
    }
}
