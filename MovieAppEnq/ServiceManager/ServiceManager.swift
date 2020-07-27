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
    
    class func load<T:Decodable>(_ resource: Resource, type: T.Type) -> Promise<T>  {
        return Promise { seal in
            if Connectivity.isConnectedToInternet() {
                AF.request(resource.url, method: HTTPMethod(rawValue: resource.method), encoding: JSONEncoding.default).response { response in
                    do {
                        if let data = response.data {
                            let item = try JSONDecoder().decode(type.self, from: data)
                            seal.resolve(.fulfilled(item))
                        }
                    }
                    catch {
                        if let error = response.error {
                            seal.reject(error.errorDescription as! Error)
                        }
                    }
                }
            } else {
                seal.reject(ApplicationError.internetError)
            }
        }
    }
    
}
