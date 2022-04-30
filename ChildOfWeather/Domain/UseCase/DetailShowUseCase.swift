import Foundation
import RxSwift

final class DetailShowUseCase {
    
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func extractTodayWeather(
        cityName: String
    ) -> Single<TodayWeather> {
        return self.weatherRepository.fetchWeatherInformation(cityName: cityName)
    }
    
    func fetchURL(from cityAddress: String) -> String {
        self.weatherRepository.fetchURLFromLocation(locationAddress: cityAddress)
    }
}

enum DataError: Error {
    case dataNotCome
}
