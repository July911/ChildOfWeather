import Foundation

enum RequestType {
    
    case getWeatherFromGeocode(lat: Double, lon: Double)
    case getWeatherFromCityName(city: String)
    case getCityNameFromGeocode(lat: Double, lon: Double)
    case getMapfromLocationInformation(location: String)
    
    var fullURL: String {
        
        switch self {
        case .getWeatherFromGeocode(let lat, let lon):
            return "\(Constant.baseURL)lat=\(lat)&lon=\(lon)&appid=\(Constant.key)"
        case .getWeatherFromCityName(let city):
            return "\(Constant.baseURL)q=" + city + "&appid=" + Constant.key
        case .getCityNameFromGeocode(let lan, let lon):
            return "\(Constant.baseURL)"
        case .getMapfromLocationInformation(let location):
            return "\(Constant.googleBaseURL)" + location
        }
    }
}


