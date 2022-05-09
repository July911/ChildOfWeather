import Foundation
import RxSwift

final class DetailWeatherFetchUseCase {
    
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func fetchTodayWeather(
        cityName: String
    ) -> Single<TodayWeather> {
        return self.weatherRepository.fetchWeatherInformation(cityName: cityName)
    }
    
    func fetchTodayWeather(latitude: Double,
        longitude: Double
    ) -> Single<TodayWeather> {
        return self.weatherRepository.fetchWeatherInformation(
            latitude: latitude,
            longitude: longitude
        )
    }
}

enum DataError: Error {
    case dataNotCome
}
