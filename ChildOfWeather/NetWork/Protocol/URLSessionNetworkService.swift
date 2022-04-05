//
//  URLSessionNetworkService.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

protocol URLSessionNetworkService {
    
    func request(
        _ type: RequestType,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}
