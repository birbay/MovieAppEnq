//
//  MoviesTableViewCell.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit
import Macaw
import Kingfisher

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var voteView: SVGView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        voteView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(movie: Movie){
        if let image = movie.poster_path {
             if let url = URL(string: ServiceManager.imageRoot + image) {
                 imgView.kf.setImage(with: url)
             }
         } else {
            imgView.image = nil
        }
        
        titleLabel.text = movie.original_title
        detailLabel.text = movie.overview
        let date = movie.release_date?.toDate(withFormat: "yyyy-MM-dd")
        dateLabel.text = date?.toString(withFormat: "d MMMM yyyy")
        if let vote = movie.vote_average {
            ratingLabel.text = String(describing: vote)
            voteView.fileName = "favorite"
        }
    }
    
}
