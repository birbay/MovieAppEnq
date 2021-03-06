//
//  SimilarCollectionViewCell.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit
import Kingfisher

class SimilarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(movie: Movie){
        contentView.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.contentView.fadeIn()
        })
        
        titleLabel.text = movie.title
        
        if let date = movie.release_date {
            let newDate = date.toDate(withFormat: "yyyy-MM-dd")
            dateLabel.text = newDate?.toString(withFormat: "d MMM yyyy")
        }
        if let image = movie.poster_path {
            if let url = URL(string: ServiceManager.imageRoot + image) {
                img.kf.setImage(with: url)
            }
        } else {
            img.image = nil
        }
    }
    
}
