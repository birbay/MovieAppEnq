//
//  SimilarMovieTableViewCell.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit
import SkeletonView

class SimilarMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    
    let cellIdentifier: String = "SimilarCollectionViewCell"
    
    var viewModel = SimilarMoviesViewModel()
    
    var goSimilarMovieCallBack: ((Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = Strings.similarMovies.localize()
        setCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SimilarMovieTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setCollectionView() {
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        similarCollectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        
        similarCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.movies.count > 0 {
            return viewModel.movies.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SimilarCollectionViewCell
        self.viewModel.isLoading ? cell.showAnimatedGradientSkeleton() : cell.hideSkeleton()
        if !viewModel.movies.isEmpty {
            cell.configureCell(movie: viewModel.movies[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let goSimilarMovieCallBack = goSimilarMovieCallBack {
            goSimilarMovieCallBack(indexPath.row)
        }
    }
    
}
