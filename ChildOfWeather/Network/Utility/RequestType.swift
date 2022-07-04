import Foundation

enum RequestType {
    
    case getWeatherFromCityName(city: String)
    case getWeatherFromLocation(latitude: Double, longitude: Double)
    case getMapfromLocationInformation(location: String)
    case getWeatherFromGeocode(lat: Double, lon: Double)
    
    var fullURL: String {
        
        switch self {
        case .getWeatherFromGeocode(let lat, let lon):
            return "\(Constant.baseURL)lat=\(lat)&lon=\(lon)&appid=\(Constant.key)"
        case .getWeatherFromCityName(let city):
            return "\(Constant.baseURL)q=" + city + "&appid=" + Constant.key + "&lang=en"
        case .getMapfromLocationInformation(let location):
            return "\(Constant.googleBaseURL)" + location
        case .getWeatherFromLocation(let lat, let lon):
            return "\(Constant.baseURL)lat=\(lat)lon=\(lon)&appid=\(Constant.key)"
        }
    }
}


