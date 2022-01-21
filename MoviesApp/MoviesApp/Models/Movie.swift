//
//  Movie.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import Foundation

struct Movie: Codable {
    var adult: Bool?
    var posterPath: String?
    var backdropPath: String?
    var budget: Int?
    var genreIDs: [Int]?
    var homepage: String?
    var id: Int?
    var imdbID: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Float?
    var releaseDate: String?
    var revenue: Int?
    var runtime: Int?
    var title: String?
    var voteAverage: Float?
    var isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case budget
        case genreIDs = "genre_ids"
        case homepage
        case id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case releaseDate = "release_date"
        case revenue
        case runtime
        case title
        case voteAverage = "vote_average"
        case isFavorite
    }
}
