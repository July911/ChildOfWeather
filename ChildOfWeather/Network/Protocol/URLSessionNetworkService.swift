import Foundation
import RxSwift

protocol URLSessionNetworkService {
    
    func request<T: APIRequest>(
        requestType: T,
        completion: @escaping (Result<T.ResponseType, APICallError>) -> Void
    ) -> URLSessionDataTask?
}

