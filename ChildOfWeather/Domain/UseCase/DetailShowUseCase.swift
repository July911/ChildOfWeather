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
        self.weatherRepository.fetchWeatherInformation(cityName: cityName) { (todayWeather) in
            guard let todayWeather = todayWeather
            else {
                return
            }
            
            completion(todayWeather)
        }
    }
    
    func fetchURL(from cityAddress: String) -> String {
        self.weatherRepository.fetchURLFromLoaction(locationAddress: cityAddress)
    }
}

enum DataError: Error {
    case dataNotCome
}
