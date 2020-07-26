//
//  ServiceManager.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class ServiceManager {
    
    static let search: String = "http://api.themoviedb.org/3/search/"
    static let root: String = "http://api.themoviedb.org/3/movie/"
    static let imageRoot: String = "https://image.tmdb.org/t/p/original"
    static let apiKey: String = "?api_key=0505e60a4582d8513db5f1322a896f71"
    
//    static let lang: String = "" // enum case TR-EN
    
    class func load(_ resource: Resource) -> Promise<Any>  {
        let (promise, resolver) = Promise<Any>.pending()
        if Connectivity.isConnectedToInternet() {
            AF.request(resource.url, method: HTTPMethod(rawValue: resource.method), encoding: JSONEncoding.default)
                .responseJSON { response in
                if let data = response.data {
                    do {
                        let items = try JSONDecoder().decode(AllMovie.self, from: data)
                        resolver.fulfill(items.results)
                    } catch {
                        resolver.reject(ApplicationError.placesCouldNotBeParsed)
                    }
                } else {
                    if let err = response.error {
                        resolver.reject(err)
                    }
                }
            }
        } else {
            resolver.reject(ApplicationError.internetError)
        }
        
        return promise
    }
}