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
        requestType: RequestType) -> Observable<Result<T, APICallError>>
    {
        
        guard let url = URL(string: requestType.fullURL)
        else {
            return Observable.error(APICallError.errorExist)
        }
        
        return Observable.create() { emitter in
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, URLResponse, error in
                
                guard error == nil
                else {
                    emitter.onError(APICallError.errorExist)
                    return
                }
                
                guard let data = data
                else {
                    emitter.onError(APICallError.dataNotfetched)
                    return
                }
                
                guard let response = URLResponse as? HTTPURLResponse
                else {
                    emitter.onError(APICallError.invalidResponse)
                    return
                }
                
                guard (200...299) ~= response.statusCode
                else {
                    emitter.onError(APICallError.notProperStatusCode)
                    return
                }
                
                guard let decodedObject = try? JSONDecoder().decode(T.self, from: data)
                else {
                    emitter.onError(APICallError.failureDecoding)
                    return
                }
                
                emitter.onNext(.success(decodedObject))
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

