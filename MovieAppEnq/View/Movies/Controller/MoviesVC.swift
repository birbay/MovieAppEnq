//
//  MoviesVC.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit
import SnapKit

class MoviesVC: BaseViewController, UISearchBarDelegate {

    var searchController: UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = Strings.search.localize()
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        return search
    }
    
    let cellIdentifier: String = "MoviesTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.movies.localize()
        
        setSearchController()
        setTableView()
    }
    
    func setSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

}

extension MoviesVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - add tableView from BaseViewController
    
    func setTableView() {
        view.addSubview(tableView)
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MoviesTableViewCell

        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nextVC = MovieDetailVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

