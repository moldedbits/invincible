//
//  CategoriesTableViewCell.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoriesTableViewCell: UITableViewCell {
    
    //Mark:- IBOutlets
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        contentView.backgroundColor = GradientColor(.leftToRight, frame: self.contentView.frame, colors: [UIColor.flatSkyBlue, UIColor.flatPowderBlueDark])
    }
    
    func configure(with category: Category) {
        separatorInset = UIEdgeInsets.zero
        categoryNameLabel.text = category.key.capitalized
    }
}
