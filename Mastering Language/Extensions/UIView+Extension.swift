//
//  UIView+Extension.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    class func loadFromNib() -> UIView? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? UIView
    }
}
