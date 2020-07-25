//
//  MovieDetailVC.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class MovieDetailVC: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Film Detail"
        
        setTableView()
    }

}

extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - add tableView from BaseViewController
    
    func setTableView() {
        view.addSubview(tableView)
        
//        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Body"
            return cell
        } else if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Genres"
            return cell
        } else {
           let cell = UITableViewCell()
           cell.textLabel?.text = "Similar"
           return cell
       }
    }
    
}

