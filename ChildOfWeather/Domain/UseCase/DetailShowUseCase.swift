import Foundation
import RxSwift

final class DetailShowUseCase {
    
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func fetchTodayWeather(
        cityName: String
    ) -> Single<TodayWeather> {
        return self.weatherRepository.fetchWeatherInformation(cityName: cityName)
    }
}

enum DataError: Error {
    case dataNotCome
}
