//
//  PassagesViewController.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import AMWaveTransition
import ChameleonFramework

class PassagesViewController: AMWaveViewController {
    
    //Mark:- IBOutlets
    @IBOutlet weak var passagesTableView: UITableView! {
        didSet {
            passagesTableView.dataSource = self
            passagesTableView.delegate = self
            passagesTableView.rowHeight = UITableViewAutomaticDimension
            passagesTableView.estimatedRowHeight = 100
            passagesTableView.register(PassagesTableViewCell.nib(), forCellReuseIdentifier: String(describing: PassagesTableViewCell.self))
            passagesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: passagesTableView.bounds.width, height: 44.0))
        }
    }
    
    //Mark:- Properties
    var selectedCategory: Category?
    var passages : [Passage] {
        guard let selectedCategory = selectedCategory else { return [] }
        return selectedCategory.passages
    }
    var passageChoosed: ((Passage) -> ())?
    
    //Mark:- Initialiser
    convenience init(selectedCategory: Category, passageChoosed: @escaping ((Passage) -> ())) {
        self.init()
        
        self.selectedCategory = selectedCategory
        self.passageChoosed = passageChoosed
        self.interactive = AMWaveTransition()
    }
    
    //Mark:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Passages"
        passagesTableView.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: [UIColor.flatPowderBlue, UIColor.flatPowderBlueDark, UIColor.flatBlue])
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
        return passagesTableView.visibleCells
    }
}

//Mark:- Extension
extension PassagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PassagesTableViewCell.self), for: indexPath) as! PassagesTableViewCell
        cell.configure(with: passages[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let passage = selectedCategory?.passages[indexPath.row] else { return }
        passageChoosed?(passage)
    }
}
