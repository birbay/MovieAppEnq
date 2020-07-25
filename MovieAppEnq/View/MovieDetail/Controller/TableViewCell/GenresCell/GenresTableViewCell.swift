//
//  GenresTableViewCell.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    let cellIdentifier = "TypeCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }
    
}

extension GenresTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setCollectionView() {
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        genresCollectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        
        if let flowLayout = genresCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 80, height: 40)
        }
        genresCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TypeCollectionViewCell
        return cell
    }
    
    
}
