//
//  Genre.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import Foundation

struct Genre: Codable {
    var id: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

struct Genres: Codable {
    var genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case genres
    }
}
