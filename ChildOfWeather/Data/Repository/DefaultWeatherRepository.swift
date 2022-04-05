//
//  WeatherRepository.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

final class DefaultWeatherRepository: WeatherRepository {
    
    let service: URLSessionNetworkService
    
    init(service: URLSessionNetworkService) {
        self.service = service
    }
}
