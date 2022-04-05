//
//  APICaller.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

enum APICallError: Error {
    case invalidResponse
    case errorExist
    case failureDecoding
    case notProperStatusCode
}

class APICaller {
    
    func request(
        _ type: RequestType,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        
        guard let url = URL(string: type.fullURL)
        else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, URLResponse, error in
            if let error = error {
                completion(.failure(APICallError.errorExist))
            }
            
            guard let response = URLResponse as? HTTPURLResponse
            else {
                completion(.failure(APICallError.invalidResponse))
                return
            }
            
            guard (200...299) ~= response.statusCode
            else {
                completion(.failure(APICallError.notProperStatusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(APICallError.invalidResponse))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
 
