import Foundation

enum APICallError: Error {
    case invalidResponse
    case errorExist
    case failureDecoding
    case notProperStatusCode
}

final class APIService {
        
    func request<T: Decodable>(
        decodedType: T.Type,
        requestType: RequestType,
        completion: @escaping (Result<T, APICallError>) -> Void
    ) {
        
        guard let url = URL(string: requestType.fullURL)
        else {
            return
        }
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, URLResponse, _ in
            
            guard let data = data else {
                return
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
            
            guard let decodedObject = try? JSONDecoder().decode(T.self, from: data)
            else {
                completion(.failure(APICallError.failureDecoding))
                return
            }
  
            completion(.success(decodedObject))
        }
        
        task.resume()
    }
}

