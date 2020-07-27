//
//  MovieRepository.swift
//  MovieAppEnq
//
//  Created by Birbay on 27.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import Foundation
import PromiseKit

class MovieRepository {
    
    class func fetchUpcomingMovies() -> Promise<AllMovie> {
        return Promise { seal in
            let resource = Resource(url: URL(string: ServiceManager.root + "upcoming" + ServiceManager.apiKey)!)
            ServiceManager.load(resource, type: AllMovie.self)
                .done { data -> Void in
                    seal.resolve(.fulfilled(data))
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    class func fetchSearchMovie(searchText: String) -> Promise<AllMovie> {
        return Promise { seal in
            let resource = Resource(url: URL(string: ServiceManager.search + "movie/" + ServiceManager.apiKey +  "&query=" + searchText + "&page=1")!)
            ServiceManager.load(resource, type: AllMovie.self)
                .done { data -> Void in
                    seal.resolve(.fulfilled(data))
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    class func fetchMovieDetail(movieID: Int) -> Promise<MovieDetail> {
        return Promise { seal in
            let resource = Resource(url: URL(string: ServiceManager.root + "\(movieID)" + ServiceManager.apiKey)!)
            ServiceManager.load(resource, type: MovieDetail.self)
                .done { data -> Void in
                    seal.resolve(.fulfilled(data))
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    class func fetchSimilarMovies(movieID: Int) -> Promise<AllMovie> {
        return Promise { seal in
            let resource = Resource(url: URL(string: ServiceManager.root + "\(movieID)/" + "similar" + ServiceManager.apiKey)!)
            ServiceManager.load(resource, type: AllMovie.self)
                .done { data -> Void in
                    seal.resolve(.fulfilled(data))
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
