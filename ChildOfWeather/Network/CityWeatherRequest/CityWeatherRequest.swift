import Foundation

struct CityWeatherRequest: APIRequest {
    
    typealias ResponseType = WeatherInformation
    
    var method: HTTPMethod
    var params: QueryParameters
    var URLString: String = "https://api.openweathermap.org/data/2.5/weather?"
    
    var HTTPBody: Data? {
        nil
    }
    var HTTPHeader: [String : String] {
        ["Content-Type": "application/json"]
    }
}


struct CityWeatherRequestParams: QueryParameters {
    
    var city: String
    var key: String = "37bcd5b2997285a9b4a7fa952b140766"
    
    var queryParam: [String : String] {
        var dictionary: [String: String] = [:]
        let city = self.city
        
        dictionary.updateValue(city, forKey: "q")
        dictionary.updateValue(self.key, forKey: "appid")
        dictionary.updateValue("kr", forKey: "lang")
        
        return dictionary
    }
}

