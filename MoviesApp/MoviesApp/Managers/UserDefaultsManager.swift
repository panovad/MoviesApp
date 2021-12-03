//
//  UserDefaultsManager.swift
//  MoviesApp
//
//  Created by Danche Panova on 3.12.21.
//

import Foundation

class UserDefaultsManager {
    
    static let sharedInstance = UserDefaultsManager()
    
    let defaults = UserDefaults.standard
    
    //MARK: - Save & Get Favorite Movies
    func saveFavoriteMovies(movies: [Movie]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(movies) {
            UserDefaults.standard.set(encoded, forKey: "favorite")
        }
    }
    
    func getFavoriteMovies() -> [Movie]? {
        if let objects = UserDefaults.standard.value(forKey: "favorite") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [Movie] {
                return objectsDecoded
            }
        } else {
            return nil
        }
        return nil
    }
}
