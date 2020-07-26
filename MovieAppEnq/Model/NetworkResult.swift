//
//  NetworkResult.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case failure(String?)
}

enum ApplicationError: Error {
    case noData
    case placesCouldNotBeParsed
    case internetError
    
    var description : String {
      switch self {
      case .noData: return Strings.error.localize()
      case .placesCouldNotBeParsed: return Strings.parse_error.localize()
      case .internetError: return Strings.internet_connection.localize()
      }
    }
}
