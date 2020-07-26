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
    
    var imageCoverHeight: CGFloat = UIScreen.main.bounds.height / 4
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
        
        transparentNavBar()
        setTableView()
        addCoverImageView()
        getData()
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
            coverImageView.addBorder(side: .bottom, color: .black, width: 2)
        } else {
            //            self.imageCoverHeight = 0
            //            self.coverImageView.layoutIfNeeded()
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
                    // MARK: - zzz make vebview
                    if let url = URL(string: "https://www.imdb.com/title/\(String(describing: imdbID))") {
                        UIApplication.shared.open(url, options: [:])
                    }
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
            }
            cell.similarCollectionView.reloadData()
            return cell
        }
    }
    
}

extension MovieDetailVC: DetailMovieModelDelegate, SimilarMoviesModelDelegate {
    func simiLarMoviesCompleted() {
        tableView.reloadSections([2], with: .fade)
    }
    
    func simiLarMoviesError(err: ApplicationError) {
        self.showActionAlert(message: err.description)
    }
    
    
    func movieCompleted() {
        fillData()
    }
    
    func movieError(err: ApplicationError) {
        self.showActionAlert(message: err.description)
    }
    
}


