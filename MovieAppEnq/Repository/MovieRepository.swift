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
    
    class func getUpcomingMovies() -> Promise<AllMovie> {
        return Promise { seal in
            let resource = Resource(url: URL(string: ServiceManager.root + "upcoming" + ServiceManager.apiKey)!)
            ServiceManager.load(resource)
                .done { data -> Void in
                    let items = try JSONDecoder().decode(AllMovie.self, from: data)
                    seal.resolve(.fulfilled(items))
                }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    class func getSearchMovie(searchText: String) -> Promise<AllMovie> {
        return Promise { seal in
            let resource = Resource(url: URL(string: ServiceManager.search + "movie/" + ServiceManager.apiKey +  "&query=" + searchText + "&page=1")!)
            ServiceManager.load(resource)
                .done { data -> Void in
                    let items = try JSONDecoder().decode(AllMovie.self, from: data)
                    seal.resolve(.fulfilled(items))
                }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    class func getMovieDetail(movieID: Int) -> Promise<MovieDetail> {
        return Promise { seal in
            let resource = Resource(url: URL(string: ServiceManager.root + "\(movieID)" + ServiceManager.apiKey)!)
            ServiceManager.load(resource)
                .done { data -> Void in
                    let item = try JSONDecoder().decode(MovieDetail.self, from: data)
                    seal.resolve(.fulfilled(item))
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    class func getSimilarMovies(movieID: Int) -> Promise<AllMovie> {
        return Promise { seal in
            let resource = Resource(url: URL(string: ServiceManager.root + "\(movieID)/" + "similar" + ServiceManager.apiKey)!)
            ServiceManager.load(resource)
                .done { data -> Void in
                    let item = try JSONDecoder().decode(AllMovie.self, from: data)
                    seal.resolve(.fulfilled(item))
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
