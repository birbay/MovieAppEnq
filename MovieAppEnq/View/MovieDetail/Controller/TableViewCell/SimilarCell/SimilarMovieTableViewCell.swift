//
//  SimilarMovieTableViewCell.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class SimilarMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    @IBOutlet weak var SimilarCollectionViewHeight: NSLayoutConstraint!
    
    let cellIdentifier: String = "SimilarCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SimilarCollectionViewCell
        
        return cell
    }
    
    
}


