import Foundation

enum APICallError: Error {
    case invalidResponse
    case errorExist
    case failureDecoding
    case notProperStatusCode
}

final class APICaller: URLSessionNetworkService {
    
    func request(
        _ type: RequestType,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        
        guard let url = URL(string: type.fullURL)
        else {
            return
        }
        
        var request = URLRequest(url: url)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, URLResponse, error in
            if let error = error {
#if DEBUG
                print(error)
#endif
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
            
            completion(.success(data!))
        }
        
        task.resume()
    }
}


struct EE {
    var visi:Int
}
