//
//  Movie.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import Foundation

struct Movie: Codable {
    var adult: Bool?
    var poster_path: String?
    var backdrop_path: String?
    var budget: Int?
    var genre_ids: [Int]?
    var homepage: String?
    var id: Int?
    var imdb_id: String?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Float?
    var release_date: String?
    var revenue: Int?
    var runtime: Int?
    var title: String?
    var vote_average: Float?
}
