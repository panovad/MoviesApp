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
    var total_results: Int?
    var total_pages: Int?
}
