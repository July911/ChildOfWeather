import Foundation

enum RequestType {
    
    case getWeatherFromGeocode(lat: Double, lon: Double)
    case getWeatherFromCityName(city: String)
    case getMapfromLocationInformation(location: String)
    
    var fullURL: String {
        
        switch self {
        case .getWeatherFromGeocode(let lat, let lon):
            return "\(Constant.baseURL)lat=\(lat)&lon=\(lon)&appid=\(Constant.key)"
        case .getWeatherFromCityName(let city):
            return "\(Constant.baseURL)q=" + city + "&appid=" + Constant.key + "&lang=en"
        case .getMapfromLocationInformation(let location):
            return "\(Constant.googleBaseURL)" + location
        }
    }
}


