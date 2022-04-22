import Foundation
import RxSwift

enum APICallError: Error {
    case invalidResponse
    case errorExist
    case failureDecoding
    case notProperStatusCode
    case dataNotfetched
}

final class APIService: URLSessionNetworkService {
    
    func request<T: Decodable>(
        decodedType: T.Type,
        requestType: RequestType) -> Single<T>
    {
        
        return Single<T>.create { single in
            
            guard let url = URL(string: requestType.fullURL)
            else {
                single(.failure(APICallError.errorExist))
                return Disposables.create()
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, URLResponse, error in
                
                guard error == nil
                else {
                    return
                }
                
                guard let data = data
                else {
                    single(.failure(APICallError.errorExist))
                    return
                }
                
                guard let response = URLResponse as? HTTPURLResponse
                else {
                    single(.failure(APICallError.errorExist))
                    return
                }
                
                guard (200...299) ~= response.statusCode
                else {
                    single(.failure(APICallError.errorExist))
                    return
                }
                
                guard let decodedObject = try? JSONDecoder().decode(T.self, from: data)
                else {
                    single(.failure(APICallError.errorExist))
                    return
                }
                
                single(.success(decodedObject))
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

