//
//  Constants.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import Foundation

struct Constants {
    
    struct Endpoints {
        
        static let baseUrl = "https://api.themoviedb.org/3"
        
        static let API_KEY = "173546c40c028e7aaf241378a8a8ae12"
        
        static let language = "&language=en-US"
        
        static let popularMovies = baseUrl + "/movie/popular?api_key=" + API_KEY + language + "&page="
        
        static let movieGenres = baseUrl + "/genre/movie/list?api_key=" + API_KEY + language
        
        static let header = [
            "Content-Type" : "application/json"
        ]
    }
}
