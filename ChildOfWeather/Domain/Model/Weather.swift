import Foundation

// MARK: - Welcome
struct WeatherInformation: Codable {
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

extension WeatherInformation {
    static let Empty = WeatherInformation(coord: Coord(lon: 0, lat: 0), weather: [], base: "", main: Main(temp: 1, feelsLike: 1, tempMin: 1, tempMax: 1, pressure: 1, humidity: 1, seaLevel: 1, grndLevel: 1), visibility: 1, wind: Wind(speed: 1, deg: 1, gust: 1), clouds: Clouds(all: 1), dt: 1, sys: Sys(type: 1, id: 1, country: "", sunrise: 1, sunset: 1), timezone: 1, id: 1, name: "", cod: 1)
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

