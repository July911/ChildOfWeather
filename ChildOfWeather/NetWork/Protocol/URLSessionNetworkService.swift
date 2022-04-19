import Foundation

protocol URLSessionNetworkService {
    
    func request<T: Decodable>(
        decodedType: T.Type,
        requestType: RequestType,
        completion: @escaping (Result<T, APICallError>) -> Void
    )
}

