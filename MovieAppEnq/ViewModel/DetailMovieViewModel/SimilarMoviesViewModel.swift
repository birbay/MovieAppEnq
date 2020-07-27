//
//  SimilarMoviesViewModel.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import Foundation

protocol SimilarMoviesModelDelegate {
    func simiLarMoviesCompleted()
    func simiLarMoviesError(err: ApplicationError?)
}

class SimilarMoviesViewModel {
    static let shared = SimilarMoviesViewModel()
    var delegate: SimilarMoviesModelDelegate?
    var movies = [Movie]()
    
    var movieID: Int?
    var isLoading: Bool = true
    
    func getSimilarMovies() {
        self.movies.removeAll()
        if let id = movieID {
            MovieRepository.fetchSimilarMovies(movieID: id)
                .done { data -> Void in
                    self.movies = data.results
                    self.delegate?.simiLarMoviesCompleted()
            }.catch { error in
                self.delegate?.simiLarMoviesError(err: error as? ApplicationError)
            }
//            #colorLiteral(red: 0.968754828, green: 0.9688635468, blue: 0.9686921239, alpha: 1)
        }
    }
}
