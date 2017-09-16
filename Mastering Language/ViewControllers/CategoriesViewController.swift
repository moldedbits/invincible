//
//  CategoriesViewController.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import PKHUD
import AMWaveTransition

class CategoriesViewController: AMWaveViewController {
    
    private var categoryTapped: ((Category) -> ())?
    private var dataManager: DataManager?
    fileprivate var categories = [Category]()
    
    //Mark:- IBOutlets
    @IBOutlet weak var categoryTableView: UITableView! {
        didSet {
            categoryTableView.dataSource = self
            categoryTableView.delegate = self
            categoryTableView.rowHeight = UITableViewAutomaticDimension
            categoryTableView.estimatedRowHeight = 100
            categoryTableView.register(CategoriesTableViewCell.nib(), forCellReuseIdentifier: String(describing: CategoriesTableViewCell.self))
            categoryTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: categoryTableView.bounds.width, height: 44.0))
        }
    }
   
    //Mark:- Initialiser
    convenience init(dataManager: DataManager?, categoryTapped: @escaping ((Category) -> ())) {
        self.init()
        
        self.dataManager = dataManager
        self.categoryTapped = categoryTapped
        self.interactive = AMWaveTransition()
    }
    
    
    //Mark:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
        HUD.show(.progress)
        HUD.dimsBackground = true
        dataManager?.getCategories()
            .then { categories -> Void in
                self.categories = categories
                self.categoryTableView.reloadData()
            }
            .always {
                HUD.hide()
            }
            .catch { error in
                print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactive.attachInteractiveGesture(to: self.navigationController!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        interactive.detachInteractiveGesture()
    }
    
    override func visibleCells() -> [Any]! {
        return categoryTableView.visibleCells
    }
}

//Mark:- Extensions
extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoriesTableViewCell.self), for: indexPath) as! CategoriesTableViewCell
        let category = categories[indexPath.row]
        cell.configure(with: category)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        categoryTapped?(category)
        
    }
}

