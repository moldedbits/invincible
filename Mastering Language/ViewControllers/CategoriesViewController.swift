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
import FSPagerView

class CategoriesViewController: AMWaveViewController {
    
    private var categoryTapped: ((Category) -> ())?
    private var dataManager: DataManager?
    fileprivate var categories = [Category]()
    private let images = [#imageLiteral(resourceName: "image1"), #imageLiteral(resourceName: "image2"), #imageLiteral(resourceName: "image9"),#imageLiteral(resourceName: "image3"), #imageLiteral(resourceName: "image4"),#imageLiteral(resourceName: "image5"),#imageLiteral(resourceName: "image6"),#imageLiteral(resourceName: "image7"),#imageLiteral(resourceName: "image8")]
    
    
    
    //Mark:- IBOutlets
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            pagerView.automaticSlidingInterval = 3.0
            pagerView.isInfinite = true
            pagerView.transformer = FSPagerViewTransformer(type: .cubic)
            pagerView.delegate = self
            pagerView.dataSource = self
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
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

extension CategoriesViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = images[index]
        cell.imageView?.contentMode = .scaleAspectFill
    
        
        return cell
    }
}

