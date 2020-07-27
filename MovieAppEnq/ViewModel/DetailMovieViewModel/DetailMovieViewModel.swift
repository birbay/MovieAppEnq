//
//  DetailMovieViewModel.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import Foundation

protocol DetailMovieModelDelegate {
    func movieCompleted()
    func movieError(err: ApplicationError?)
}

class DetailMovieViewModel {
    static let shared = DetailMovieViewModel()
    var delegate: DetailMovieModelDelegate?
    
    var movie = MovieDetail()
    
    var isLoading: Bool = true
    
    var sectionCount: Int {
        return 3 // body, genres, similar
    }
    
    func getMovie() {
        if let id = movie.id {
            MovieRepository.getMovieDetail(movieID: id)
                .done { data -> Void in
                    self.movie = data
                    self.delegate?.movieCompleted()
            }.catch { error in
                self.delegate?.movieError(err: error as? ApplicationError)
            }
        }
    }
}
