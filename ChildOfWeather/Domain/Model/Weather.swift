import Foundation

struct WeatherInfomation: Codable {
    
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable {
    
    let lon, lat: Double
}

struct Main: Codable {
    
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct Wind: Codable {
    
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    
    let all: Int
}

struct Weather: Codable {
    
    let id: Int
    let main, weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

struct Sys: Codable {
    
    let type, id: Int
    let message: Double
    let country: String
    let sunrise, sunset: Int
}
