//
//  CategoriesTableViewCell.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    func configure(with type: CategoryList) {
        separatorInset = UIEdgeInsets.zero
        categoryLabel.text = type.categoryType
    }

}
