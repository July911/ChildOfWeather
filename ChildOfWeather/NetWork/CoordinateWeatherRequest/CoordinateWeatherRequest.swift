//
//  CityWeatherRequest.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/05/15.
//

import Foundation

struct CoordinateWeatherRequest: APIRequest {
    
    typealias ResponseType = WeatherInformation
    
    var method: HTTPMethod
    var params: QueryParameters
    var urlString: String = "https://api.openweathermap.org/data/2.5/weather?"
}


struct CoordinateWeatherRequestParams: QueryParameters {
    
    var latitude: Double
    var longitude: Double
    var key: String = "37bcd5b2997285a9b4a7fa952b140766"
    
    var queryParam: [String : String] {
        var dictionary: [String: String] = [:]
        let latitude = self.latitude.description
        let longitude = self.longitude.description
        
        dictionary.updateValue(latitude, forKey: "lat")
        dictionary.updateValue(longitude, forKey: "lon")
        dictionary.updateValue(self.key, forKey: "appid")
        dictionary.updateValue("kr", forKey: "lang")
        
        return dictionary
    }
}
