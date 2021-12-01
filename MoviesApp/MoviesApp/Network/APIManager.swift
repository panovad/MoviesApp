//
//  APIManager.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import Foundation

typealias CompletionCallBack = ((_ success: Bool, _ response: Data?, _ statusCode : Int?)-> ())?

class APIManager {
    
    static let sharedInstance = APIManager()
    
    var statusCode: Int!
    
    func makeRequest(path: String, completion: CompletionCallBack) {
        let url = URL(string: path)!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in

            if let httpResponse = response as? HTTPURLResponse {
                self.statusCode = httpResponse.statusCode
            }
            
            guard error == nil else {
                completion!(false, nil, self.statusCode)
                return
            }

            guard let data = data else {
                completion!(false, nil, self.statusCode)
                return
            }
            
            completion!(true, data, self.statusCode)
        }
        
        task.resume()
    }
}

enum APPError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

enum Result<T> {
    case success(T)
    case failure(APPError)
}

