import Foundation

final class DetailShowUseCase {
    
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func extractTodayWeather(
        cityName: String,
        completion: @escaping (TodayWeather) -> Void
    ) {
        self.weatherRepository.getWeatherInformation(cityName: cityName) { (todayWeather) in
            guard let todayWeather = todayWeather
            else {
                return
            }
            
            completion(todayWeather)
        }
    }
    
    func getURL(from cityAdress: String) -> String {
        self.weatherRepository.getURLFromLoaction(locationAdress: cityAdress)
    }
}

enum dataError: Error {
    case dataNotCome
}
