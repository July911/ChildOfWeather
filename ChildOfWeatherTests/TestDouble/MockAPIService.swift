import Foundation
@testable import ChildOfWeather

final class MockAPIService: URLSessionNetworkService {
    
    func request<T>(decodedType: T.Type, requestType: RequestType, completion: @escaping (Result<T, APICallError>) -> Void) where T : Decodable {
        
        guard let mockObject = try? JSONDecoder().decode(T.self, from: Data())
        else {
            return completion(.failure(APICallError.failureDecoding))
        }
        
        completion(.success(mockObject))
    }
}


