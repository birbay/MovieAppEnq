//
//  MovieViewModel.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

protocol MovieModelDelegate {
    func moviesCompleted()
    func moviesError(err: ApplicationError?)
}

class MovieViewModel {
    static let shared = MovieViewModel()
    
    var delegate: MovieModelDelegate?
    
    var movies = [Movie]()
    
    var isLoading: Bool = true
    var dummyDataCount: Int = 10
    
    func refreshHandle() {
        getMovies()
    }
    
    func getMovies() {
        self.movies.removeAll()
        MovieRepository.fetchUpcomingMovies()
            .done { data -> Void in
                self.movies = data.results
                self.delegate?.moviesCompleted()
        }.catch { error in
            self.delegate?.moviesError(err: error as? ApplicationError)
        }
    }
    
    func getSearchMovie(searchText: String) {
        movies.removeAll()
        MovieRepository.fetchSearchMovie(searchText: searchText)
            .done { data -> Void in
                self.movies = data.results
                self.delegate?.moviesCompleted()
        }.catch { error in
            self.delegate?.moviesError(err: error as? ApplicationError)
        }
    }
}

