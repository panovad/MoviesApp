//
//  PaginationMovies.swift
//  MoviesApp
//
//  Created by Danche Panova on 1.12.21.
//

import Foundation

struct PaginationMovies: Codable {
    var page: Int?
    var results: [Movie]?
    var totalResults: Int?
    var totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
