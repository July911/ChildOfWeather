import Foundation
import RxSwift

final class URLSessionService: URLSessionNetworkService {
    
    private let session = URLSession.shared
    
    func request<T: APIRequest>(
        requestType: T,
        completion: @escaping (Result<T.ResponseType, APICallError>) -> Void
    ) -> URLSessionDataTask? {
        
        guard let request = requestType.urlRequest else {
            completion(.failure(.errorExist))
            return nil
        }

        let task = self.session.dataTask(with: request) { data, response, error in
            
                guard error == nil else {
                    completion(.failure(.errorExist))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard (200...299) ~= httpResponse.statusCode else {
                    print(httpResponse.statusCode)
                    completion(.failure(.notProperStatusCode(code: httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.dataNotfetched))
                    return
                }
                
                guard let parsed = try? JSONDecoder().decode(T.ResponseType.self, from: data) else {
                    completion(.failure(.failureDecoding))
                    return
                }
                
                completion(.success(parsed))
            }
            
        task.resume()
        
        return task
    }
}

enum APICallError: Error {
    
    case invalidResponse
    case errorExist
    case failureDecoding
    case notProperStatusCode(code: Int)
    case dataNotfetched
}


