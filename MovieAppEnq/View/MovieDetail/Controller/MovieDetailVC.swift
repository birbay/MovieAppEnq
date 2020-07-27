//
//  MovieDetailVC.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit
import SkeletonView
import FirebaseAnalytics

class MovieDetailVC: BaseViewController {
    
    lazy var coverImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: imageCoverHeight))
        image.backgroundColor = .systemGray6
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isSkeletonable = true
        image.showAnimatedGradientSkeleton()
        image.backgroundColor = UIColor.systemGray5
        return image
    }()
    
    lazy var coverViewOfImage: UIView = {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: imageCoverHeight))
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return coverView
    }()
    
    var headerView: UIView = {
        let size: CGFloat = 25
        let width = UIScreen.main.bounds.width
        var containerView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        containerView.clipsToBounds = false
        containerView.backgroundColor = .clear
        
        let viewTop = UIView(frame: CGRect(x: 0, y: -size, width: width, height: size*2))
        viewTop.backgroundColor = .systemBackground
        viewTop.layer.cornerRadius = size
        viewTop.dropShadow(color: .black, opacity: 0.8, offSet: CGSize(width: -1, height: 1), radius: 12, scale: true)
        containerView.addSubview(viewTop)
        return containerView
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        transparentNavBar()
        self.setNavbar(backgroundColorAlpha: navBarAlpha)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let md = MovieDetail()
        viewModel.movie = md
    }
    
    func getData(){
        viewModel.isLoading = true
        similarViewModel.isLoading = true
        
        viewModel.getMovie()
        
        if let id = viewModel.movie.id {
            similarViewModel.movieID = id
        }
        similarViewModel.getSimilarMovies()
        self.tableView.reloadData()
    }
    
    func fillData() {
        
        if let id = viewModel.movie.id, let name = viewModel.movie.title {
            Analytics.logEvent("movieDetail", parameters: [
                "movieName": name as NSObject,
                "movieID": id as NSObject
            ])
        }
        
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
        coverImageView.hideSkeleton()
        
        self.tableView.reloadData()
    }
    
    func addCoverImageView() {
        
        // MARK: - addImageCover
        view.addSubview(coverImageView)
        view.bringSubviewToFront(coverViewOfImage)
        view.addSubview(coverViewOfImage)
        view.bringSubviewToFront(tableView)
    }
    
    // MARK: - ScrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // MARK: - imageCoverHeight
        let y = imageCoverHeight - (scrollView.contentOffset.y + imageCoverHeight )
        //        let h = max(topbarHeight - 20, y)
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: y) // header / 2
        coverImageView.frame = rect
        coverViewOfImage.frame = rect
        
        // MARK: - when scroll navbar transparent progress
        let denominator: CGFloat = 30
        navBarAlpha = min(1, (scrollView.contentOffset.y + denominator + topbarHeight) / denominator)
        self.setNavbar(backgroundColorAlpha: navBarAlpha)
        
    }
    
}

extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - add tableView from BaseViewController
    
    func setTableView() {
        view.addSubview(tableView)
        
        tableView.tableHeaderView = headerView
        headerView.layer.zPosition = -1
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(0.0))
        
        tableView.backgroundColor = .clear
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierBody, for: indexPath) as! MovieDetailBodyTableViewCell
            self.viewModel.isLoading ? cell.showAnimatedGradientSkeleton() : cell.hideSkeleton()
            cell.configureCell(movie: viewModel.movie)
            cell.imdbCallBack = {
                if let imdbID = self.viewModel.movie.imdb_id {
                    let nextVC = IMDBWebViewVC()
                    nextVC.imdbID = imdbID
                    self.navigationController?.push(viewController: nextVC,
                                                    transitionType: CATransitionType.moveIn.rawValue,
                                                    transitionsubtype: CATransitionSubtype.fromRight.rawValue,
                                                    duration: 0.3)
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierGenres, for: indexPath) as! GenresTableViewCell
            self.viewModel.isLoading ? cell.showAnimatedGradientSkeleton() : cell.hideSkeleton()
            if !self.viewModel.movie.genres.isEmpty {
                cell.viewModel.isLoading = false
                cell.viewModel.genres = viewModel.movie.genres
                cell.genresCollectionView.reloadData()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierSimilar, for: indexPath) as! SimilarMovieTableViewCell
            self.similarViewModel.isLoading ? cell.showAnimatedGradientSkeleton() : cell.hideSkeleton()
            if !self.similarViewModel.movies.isEmpty {
                cell.viewModel.isLoading = similarViewModel.isLoading
                cell.viewModel.movies = self.similarViewModel.movies
                cell.goSimilarMovieCallBack = { index in
                    let data = self.similarViewModel.movies[index]
                    let nextVC = MovieDetailVC()
                    if let id = data.id, let name = data.original_title {
                        nextVC.viewModel.movie.id = id
                        Analytics.logEvent("similarMovies", parameters: [
                            "movieName": name as NSObject,
                            "movieID": id as NSObject
                        ])
                    }
                    
                    self.navigationController?.push(viewController: nextVC,
                                                    transitionType: CATransitionType.moveIn.rawValue,
                                                    transitionsubtype: CATransitionSubtype.fromRight.rawValue,
                                                    duration: 0.3)
                }
            }
            cell.similarCollectionView.reloadData()
            return cell
        }
    }
    
}

extension MovieDetailVC: DetailMovieModelDelegate, SimilarMoviesModelDelegate {
    func simiLarMoviesCompleted() {
        similarViewModel.isLoading = false
        tableView.reloadSections([2], with: .fade)
    }
    
    func simiLarMoviesError(err: ApplicationError?) {
        self.showActionAlert(message: err?.description ?? "")
    }
    
    func movieCompleted() {
        viewModel.isLoading = false
        fillData()
    }
    
    func movieError(err: ApplicationError?) {
        self.showActionAlert(message: err?.description ?? "")
    }
    
}


extension MovieDetailVC: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "GenresTableViewCell"
    }
}
