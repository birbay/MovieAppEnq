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
    func simiLarMoviesError(err: ApplicationError)
}

class SimilarMoviesViewModel {
    static let shared = SimilarMoviesViewModel()
    var delegate: SimilarMoviesModelDelegate?
    var movies = [Movie]()
    
    var id: Int = 0
    var isLoading: Bool = true
    
    func getSimilarMovies() {
        self.movies.removeAll()
        let resource = Resource(url: URL(string: ServiceManager.root + "\(id)/" + "similar" + ServiceManager.apiKey)!)
        ServiceManager.load(resource)
            .done { data -> Void in
                self.movies = data as! [Movie]
                self.delegate?.simiLarMoviesCompleted()
            }.catch { error in
                self.delegate?.simiLarMoviesError(err: error as! ApplicationError)
        }
    }
}
