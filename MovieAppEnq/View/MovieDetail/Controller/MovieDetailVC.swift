//
//  MovieDetailVC.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class MovieDetailVC: BaseViewController {
    
    lazy var coverImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: imageCoverHeight))
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var imageCoverHeight: CGFloat = 0 // UIScreen.main.bounds.height / 4
    let cellIdentifierBody: String = "MovieDetailBodyTableViewCell"
    let cellIdentifierGenres: String = "GenresTableViewCell"
    let cellIdentifierSimilar: String = "SimilarMovieTableViewCell"
    
    lazy var viewModel: DetailMovieViewModel = {
        let vm = DetailMovieViewModel.shared
        vm.delegate = self
        return vm
    }()
    
    lazy var similarViewModel: SimilarMoviesViewModel = {
        let vm = SimilarMoviesViewModel.shared
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        addCoverImageView()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        transparentNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let md = MovieDetail()
        viewModel.movie = md
        similarViewModel.movies.removeAll()
    }
    
    func getData(){
        viewModel.getMovie()
        
        if let id = viewModel.movie.id {
            similarViewModel.id = id
        }
        similarViewModel.getSimilarMovies()
    }
    
    func fillData() {
        
        // MARK: - FillImageCover
        if let image = self.viewModel.movie.backdrop_path {
            if let url = URL(string: ServiceManager.imageRoot + image) {
                self.coverImageView.kf.setImage(with: url)
            }
            self.coverImageView.addBorder(side: .bottom, color: .black, width: 2)
            self.imageCoverHeight = UIScreen.main.bounds.height / 4
            self.tableView.contentInset = UIEdgeInsets(top: imageCoverHeight + topbarHeight, left: 0, bottom: 30, right: 0)
        } else {
            self.coverImageView.image = nil
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        }
        
        self.tableView.reloadData()
    }
    
    func addCoverImageView() {
        
        // MARK: - addImageCover
        view.addSubview(coverImageView)
    }
    
    // MARK: - ScrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // MARK: - imageCoverHeight
        let y = imageCoverHeight - (scrollView.contentOffset.y + imageCoverHeight )
//        let h = max(topbarHeight - 20, y)
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: y) // header / 2
        coverImageView.frame = rect
        
        // MARK: - when scroll navbar transparent progress
        let denominator: CGFloat = 50
        let alpha = min(1, (scrollView.contentOffset.y + denominator * 2) / denominator)
        self.setNavbar(backgroundColorAlpha: alpha)
    }
    
}

extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - add tableView from BaseViewController
    
    func setTableView() {
        view.addSubview(tableView)
        
        loadingIndicatorView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 50)
        tableView.addSubview(loadingIndicatorView)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: imageCoverHeight + topbarHeight, left: 0, bottom: 30, right: 0)
        
        tableView.register(UINib(nibName: cellIdentifierBody, bundle: nil), forCellReuseIdentifier: cellIdentifierBody)
        tableView.register(UINib(nibName: cellIdentifierGenres, bundle: nil), forCellReuseIdentifier: cellIdentifierGenres)
        tableView.register(UINib(nibName: cellIdentifierSimilar, bundle: nil), forCellReuseIdentifier: cellIdentifierSimilar)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if self.viewModel.movie.genres.isEmpty {
                return 0
            }
        } else if indexPath.section == 2 {
            if self.similarViewModel.movies.isEmpty {
                return 0
            }
        }
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 0.001
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierBody, for: indexPath) as! MovieDetailBodyTableViewCell
            cell.configureCell(movie: viewModel.movie)
            cell.imdbCallBack = {
                if let imdbID = self.viewModel.movie.imdb_id {
                    let nextVC = IMDBWebViewVC()
                    nextVC.imdbID = imdbID
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierGenres, for: indexPath) as! GenresTableViewCell
            if !self.viewModel.movie.genres.isEmpty {
                cell.viewModel.genres = viewModel.movie.genres
            }
            cell.genresCollectionView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierSimilar, for: indexPath) as! SimilarMovieTableViewCell
            if !self.similarViewModel.movies.isEmpty {
                cell.viewModel.movies = self.similarViewModel.movies
                cell.goSimilarMovieCallBack = { index in
                    let data = self.similarViewModel.movies[index]
                    let nextVC = MovieDetailVC()
                    if let id = data.id {
                        nextVC.viewModel.movie.id = id
                    }
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                cell.similarCollectionView.reloadData()
                return cell
            } else {
                let cell = UITableViewCell()
                if similarViewModel.isLoading == true {
                    let activityIndicator = UIActivityIndicatorView(style: .medium)
                    activityIndicator.color = UIColor.label
                    activityIndicator.startAnimating()
                    activityIndicator.hidesWhenStopped = true
                    activityIndicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 50)
                    cell.addSubview(activityIndicator)
                }
                return cell
            }
            
        }
    }
    
}

extension MovieDetailVC: DetailMovieModelDelegate, SimilarMoviesModelDelegate {
    func simiLarMoviesCompleted() {
        similarViewModel.isLoading = false
        tableView.reloadSections([2], with: .fade)
    }
    
    func simiLarMoviesError(err: Error) {
        self.showActionAlert(message: err.localizedDescription)
    }
    
    func movieCompleted() {
        loadingIndicatorView.stopAnimating()
        fillData()
    }
    
    func movieError(err: ApplicationError) {
        self.showActionAlert(message: err.description)
    }
    
}


