import Foundation
import RxSwift

extension URLSessionNetworkService {

    func requestRx<T: APIRequest>(request: T) -> Observable<T.ResponseType> {
        return Observable.create { emitter in
            let task = self.request(requestType: request) { result in
                switch result {
                case .success(let result):
                    emitter.onNext(result)
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }

            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
