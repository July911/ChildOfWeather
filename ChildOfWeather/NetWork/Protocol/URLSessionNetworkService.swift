import Foundation

protocol URLSessionNetworkService {
    
    associatedtype decodedType: Decodable
    
    func request(
        _ type: RequestType,
        completion: @escaping (Result<decodedType, Error>) -> Void
    )
}
