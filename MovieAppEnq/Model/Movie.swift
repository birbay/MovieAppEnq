//
//  Movie.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class AllMovie: Codable {
    var results: [Movie]
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
}

class Movie: Codable {
    var popularity: Double?
    var vote_count: Int?
    var video: Bool?
    var poster_path: String?
    var id: Int?
    var adult: Bool?
    var backdrop_path: String?
    var original_language: String?
    var original_title: String?
    var title: String?
    var vote_average: Double?
    var overview: String?
    var release_date: String?
    var genre_ids: [Int]?
}

