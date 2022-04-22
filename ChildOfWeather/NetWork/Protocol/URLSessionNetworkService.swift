import Foundation
import RxSwift

protocol URLSessionNetworkService {
    
    func request<T: Decodable>(
        decodedType: T.Type,
        requestType: RequestType) -> Observable<Result<T, APICallError>>
}

