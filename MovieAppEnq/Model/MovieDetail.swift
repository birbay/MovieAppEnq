//
//  MovieDetail.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import Foundation

class MovieDetail: Codable {
    var backdrop_path: String?
    var genres = [Genres]()
    var id: Int?
    var imdb_id: String?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var vote_average: Double?
}
