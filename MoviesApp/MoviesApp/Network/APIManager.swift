//
//  APIManager.swift
//  MoviesApp
//
//  Created by Danche Panova on 30.11.21.
//

import Foundation
import UIKit

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
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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

