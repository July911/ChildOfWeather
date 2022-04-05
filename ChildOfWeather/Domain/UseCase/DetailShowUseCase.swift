//
//  DetailShowUseCase.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

final class DetailShowUseCase {
    
    let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
}
