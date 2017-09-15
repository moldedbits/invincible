//
//  CategoriesTableViewCell.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    //Mark:- IBOutlets
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    func configure(with type: CategoryList) {
        separatorInset = UIEdgeInsets.zero
        categoryNameLabel.text = type.categoryType
    }
}
