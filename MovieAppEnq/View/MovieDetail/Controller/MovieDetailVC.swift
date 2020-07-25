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
        image.backgroundColor = UIColor.systemGray2
        return image
    }()
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    let imageCoverHeight: CGFloat = UIScreen.main.bounds.height / 4
    let cellIdentifierBody: String = "MovieDetailBodyTableViewCell"
    let cellIdentifierGenres: String = "GenresTableViewCell"
    let cellIdentifierSimilar: String = "SimilarMovieTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transparentNavBar()
        setTableView()
        fillData()
        addCoverImageView()
    }
    
    func fillData() {
        
        // MARK: - FillImageCover
        
        self.coverImageView.image = UIImage(named: "interstellar")
        
    }

    func addCoverImageView() {

        // MARK: - addImageCover
        coverImageView.addBorder(side: .bottom, color: .black, width: 2)
        view.addSubview(coverImageView)
        
    }
    
        // MARK: - ScrollView
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = imageCoverHeight - (scrollView.contentOffset.y + imageCoverHeight )
//        let h = max(topbarHeight - 20, y)
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: y) // header / 2
        coverImageView.frame = rect
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
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierBody, for: indexPath) as! MovieDetailBodyTableViewCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierGenres, for: indexPath) as! GenresTableViewCell
            
            cell.genresCollectionView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierSimilar, for: indexPath) as! SimilarMovieTableViewCell
           return cell
       }
    }
    
}

