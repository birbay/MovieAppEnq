//
//  MovieDetailBodyTableViewCell.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class MovieDetailBodyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    var imdbCallBack: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func goIMDBPage(_ sender: Any) {
        if let imdbCallBack = imdbCallBack {
            imdbCallBack()
        }
    }
    
    func configureCell(movie: MovieDetail){
        titleLabel.text = movie.title
        
        if let desc = movie.overview {
            descLabel.text = desc
        }
        
        if let vote = movie.vote_average {
            voteAverageLabel.text = String(vote)
        }
        
        if let image = movie.poster_path {
            if let url = URL(string: ServiceManager.imageRoot + image) {
                imgView.kf.setImage(with: url)
            }
        } else {
            imgView.image = nil
        }
    }
}
