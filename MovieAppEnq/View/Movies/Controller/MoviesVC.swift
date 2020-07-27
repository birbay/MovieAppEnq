//
//  MoviesVC.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit
import SnapKit
import SkeletonView

class MoviesVC: BaseViewController, UISearchBarDelegate {
    
    var searchController: UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = Strings.search.localize()
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        return search
    }
    
    lazy var viewModel: MovieViewModel = {
        let vm = MovieViewModel.shared
        vm.delegate = self
        return vm
    }()
    
    let cellIdentifier: String = "MoviesTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.upcomingMovies.localize()
        setLoadingIndicatorToBarButton()
        setSearchController()
        setTableView()
        viewModel.getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - to bring navBar back if transparentNavBar run
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc override func refreshHandle(){
        viewModel.isLoading = true
        self.tableView.reloadData()
        if navigationItem.searchController?.searchBar.text == "" {
            viewModel.refreshHandle()
        } else {
            if let query = navigationItem.searchController?.searchBar.text {
                viewModel.getSearchMovie(searchText: query)
            }
        }
    }
    
    
    // MARK: - SearchController
    
    func setSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.isLoading = true
        tableView.reloadData()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getSearchMovie(_:)), object: searchBar)
        perform(#selector(getSearchMovie(_:)), with: searchBar, afterDelay: 0.5)
    }
    
    @objc func getSearchMovie(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            query != "" ? viewModel.getSearchMovie(searchText: query) : viewModel.getMovies()
        }
    }
    
}

extension MoviesVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - add tableView from BaseViewController
    
    func setTableView() {
        view.addSubview(tableView)
        tableView.addSubview(refreshControl!)
        
        refreshControl?.addTarget(self, action: #selector(refreshHandle), for: UIControl.Event.valueChanged)
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.movies.count > 0 {
            tableView.restore()
            return viewModel.movies.count
        } else {
            if !viewModel.isLoading {
                tableView.setEmptyView(title: Strings.error.localize(), message: Strings.emptyTableView.localize(), svgName: "no_movie")
            } else {
                tableView.restore()
            }
            return viewModel.dummyDataCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MoviesTableViewCell
        viewModel.isLoading ? cell.showAnimatedGradientSkeleton() : cell.hideSkeleton()
        if !viewModel.movies.isEmpty {
            let data = viewModel.movies[indexPath.row]
            cell.configureCell(movie: data)
            
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.isLoading == false {
            let nextVC = MovieDetailVC()
            let data = viewModel.movies[indexPath.row]
            if let id = data.id {
                nextVC.viewModel.movie.id = id
            }
            navigationController?.push(viewController: nextVC,
                                       transitionType: CATransitionType.moveIn.rawValue,
                                       transitionsubtype: CATransitionSubtype.fromRight.rawValue,
                                       duration: 0.3)
        }
    }
}

extension MoviesVC: MovieModelDelegate {
    func moviesCompleted() {
        loadingIndicatorView.stopAnimating()
        viewModel.isLoading = false
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    func moviesError(err: ApplicationError?) {
        viewModel.isLoading = false
        loadingIndicatorView.stopAnimating()
        self.refreshControl?.endRefreshing()
        self.showActionAlert(message: err?.description ?? "")
        viewModel.dummyDataCount = err?.id == 2 ? 0 : 10 
        self.tableView.reloadData()
    }
    
}

extension MoviesVC: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MoviesTableViewCell"
    }
}
