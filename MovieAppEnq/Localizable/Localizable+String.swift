//
//  Localizable+String.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

public enum Strings: String {
    
    // MARK: String enums
    case search                         = "search"
    case movies                         = "movies"
    case upcomingMovies                 = "upcomingMovies"
    case similarMovies                  = "similarMovies"
    case warning                        = "warning"
    case error                          = "error"
    case parse_error                    = "parse_error"
    case ok                             = "ok"
    case internet_connection            = "internet_connection"
    case emptyTableView                 = "emptyTableView"
    
    func localize() -> String {
        return NSLocalizedString(self.rawValue, comment:"")
    }
    
}
