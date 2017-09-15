//
//  CategoriesViewController.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
  
    private var categoryType = ["Hello!", "Let's Go For Tea", "It's Lunch Time", "Yippee! Party Party"]
    private var categoryTapped: (() -> ())?
    private var dataManager: DataManager?
    
    //Mark:- IBOutlets
    @IBOutlet weak var categoryTableView: UITableView! {
        didSet {
            categoryTableView.dataSource = self
            categoryTableView.delegate = self
            categoryTableView.rowHeight = UITableViewAutomaticDimension
            categoryTableView.estimatedRowHeight = 44.0
            categoryTableView.register(CategoriesTableViewCell.nib(), forCellReuseIdentifier: String(describing: CategoriesTableViewCell.self))
            categoryTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: categoryTableView.bounds.width, height: 44.0))
        }
    }
    
    //Mark:- Initialiser
    convenience init(dataManager: DataManager?, categoryTapped: @escaping (() -> ())) {
        self.init()
        
        self.dataManager = dataManager
        self.categoryTapped = categoryTapped
    }
    
    
    //Mark:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        dataManager?.getCategories()
            .then { categories in
                print(categories)
        }
            .catch { error in
                print(error.localizedDescription)
        }
    }
}


extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoriesTableViewCell.self), for: indexPath) as! CategoriesTableViewCell
        cell.configure(with: CategoryList(categoryType: categoryType[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryTapped?()
    }
}

