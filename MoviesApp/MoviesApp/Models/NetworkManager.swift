//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Danche Panova on 21.1.22.
//

import Foundation
import SystemConfiguration
import UIKit

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    typealias MoviesCompletion = ((PaginationMovies?, Error?) ->())
    typealias GenresCompletion = ((Genres?, Error?) ->())
    
    var baseUrl = "https://api.themoviedb.org/3"
    var API_KEY = "173546c40c028e7aaf241378a8a8ae12"
    var language = "&language=en-US"
    var header = [
        "Content-Type" : "application/json"
    ]
    
    //    var popularMovies = baseUrl + "/movie/popular?api_key=" + API_KEY + language + "&page="
    //    var movieGenres = baseUrl + "/genre/movie/list?api_key=" + API_KEY + language

    //Check if device has Internet Connection
    func hasInternetConnection() -> Bool {
        return Reachability.sharedInstance.isInternetAvailable()
    }
    
    //Request Creation
    private func createRequest(url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    //Request Execution
    private func executeRequest<T: Codable>(request: URLRequest, completion: ((T?, Error?) -> ())?) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion?(decodedResponse, nil)
                }
            } else {
                completion?(nil, NetworkError.invalidData)
            }
        }
        dataTask.resume()
    }
    
    //Get Popular Movies
    func getPopularMovies(page: Int, completion: @escaping MoviesCompletion) {
        let url = baseUrl + "/movie/popular?api_key=" + API_KEY + language + "&page=" + "\(page)"
        guard let request = createRequest(url: url) else {
            completion(nil, NetworkError.invalidUrl)
            return
        }
        executeRequest(request: request, completion: completion)
    }
    
    //Get Different Movie Genres
    func getMovieGenres(completion: @escaping GenresCompletion) {
        let url = baseUrl + "/genre/movie/list?api_key=" + API_KEY + language
        guard let request = createRequest(url: url) else {
            completion(nil, NetworkError.invalidUrl)
            return
        }
        executeRequest(request: request, completion: completion)
    }
    
    //Download Image
    func downloadImage(from url: URL, imageView: UIImageView) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    //Get Image Data
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}

class Reachability {
    
    static let sharedInstance = Reachability()
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

enum NetworkError: Error {
    case invalidUrl
    case invalidData
}
