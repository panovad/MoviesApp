//
//  Constants.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import Foundation

struct Constants {
    
    struct Endpoints {
        
        static let baseUrl = "https://api.themoviedb.org/3/movie/"
        
        static let API_KEY = "173546c40c028e7aaf241378a8a8ae12"
        
        static let popularMovies = baseUrl + "popular?api_key=" + API_KEY + "&language=en-US&page="
        
        static let header = [
            "Content-Type" : "application/json"
        ]
    }
}
