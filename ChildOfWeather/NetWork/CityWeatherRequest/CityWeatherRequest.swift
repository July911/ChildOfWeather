//
//  GoogleSearchRequest.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/05/15.
//

import Foundation

struct CityWeatherRequest: APIRequest {
    
    typealias ResponseType = WeatherInformation
    
    var method: HTTPMethod
    var params: QueryParameters
    var urlString: String = "https://api.openweathermap.org/data/2.5/weather?"
}


struct CityWeatherRequestParams: QueryParameters {
    
    var city: String
    var key: String = "37bcd5b2997285a9b4a7fa952b140766"
    
    var queryParam: [String : String] {
        var dictionary: [String: String] = [:]
        let city = self.city
        
        dictionary.updateValue(city, forKey: "city")
        dictionary.updateValue(self.key, forKey: "appid")
        
        return dictionary
    }
}

