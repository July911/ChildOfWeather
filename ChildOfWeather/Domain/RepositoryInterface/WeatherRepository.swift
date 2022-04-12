import Foundation

protocol WeatherRepository {
    
    func getWeatherInformation(
        cityName text: String,
        completion: @escaping (TodayWeather?) -> Void
    )
    
    func getURLFromLoaction(locationAdress adress: String) -> String
}
