//
//  MovieViewModel.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import Foundation

protocol MovieModelDelegate {
    func moviesCompleted()
    func moviesError(err: Error)
}

class MovieViewModel {
    static let shared = MovieViewModel()
    
    var delegate: MovieModelDelegate?
    
    var movies = [Movie]()
    
    var isLoading: Bool = true
    
    func refreshHandle() {
        getMovies()
    }
    
    // MARK: - zzzz I'll put somewhere else these later
    
    func getMovies() {
        movies.removeAll()
        let resource = Resource(url: URL(string: ServiceManager.root + "upcoming" + ServiceManager.apiKey)!)
        ServiceManager.load(resource)
            .done { data -> Void in
                self.movies = data as! [Movie]
                self.delegate?.moviesCompleted()
            }.catch { error in
                self.delegate?.moviesError(err: error)
        }
    }
    
    func getSearchMovie(searchText: String) {
        movies.removeAll()
        let resource = Resource(url: URL(string: ServiceManager.search + "movie/" + ServiceManager.apiKey +  "&query=" + searchText + "&page=1")!)
        ServiceManager.load(resource)
            .done { data -> Void in
            self.movies = data as! [Movie]
                self.delegate?.moviesCompleted()
            }.catch { error in
                self.delegate?.moviesError(err: error)
        }
    }
}
