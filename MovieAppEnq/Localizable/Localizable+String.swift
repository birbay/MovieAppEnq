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
    case movies                         = "movies"
    case search                         = "search"
    case warning                        = "warning"
    case error                          = "error"
    
    func localize() -> String {
        return NSLocalizedString(self.rawValue, comment:"")
    }
    
}
