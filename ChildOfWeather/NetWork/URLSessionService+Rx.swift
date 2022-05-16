//
//  URLSessionService+Rx.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/05/15.
//

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