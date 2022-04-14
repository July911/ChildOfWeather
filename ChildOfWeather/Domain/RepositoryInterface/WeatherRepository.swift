import Foundation

protocol WeatherRepository {
    
    func fetchWeatherInformation(
        cityName text: String,
        completion: @escaping (TodayWeather?) -> Void
    )
    
    func fetchURLFromLoaction(locationAddress address: String) -> String
}
