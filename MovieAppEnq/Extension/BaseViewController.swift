//
//  BaseViewController.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - tableView
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .singleLine
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func transparentNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}
