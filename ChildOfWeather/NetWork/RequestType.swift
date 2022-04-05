//
//  HTTPMethod.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

enum RequestType {
    
    case getWeatherFromGeocode(lat: Double, lon: Double)
    case getWeatherFromCityName(city: String)
    case getCityNameFromGeocode(lat: Double, lon: Double)
    
    var fullURL: String {
        
        switch self {
        case .getWeatherFromGeocode(let lat, let lon):
            return "\(Constant.baseURL)?lat=\(lat)&lon=\(lon)&appid=\(Constant.key)"
        case .getWeatherFromCityName(let city):
            return "\(Constant.baseURL)?q=\(city)&appid=\(Constant.key)"
        case .getCityNameFromGeocode(let lan, let lon):
            return "\(Constant.baseURL)"
        }
    }
}
