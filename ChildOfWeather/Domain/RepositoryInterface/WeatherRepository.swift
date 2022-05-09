import Foundation
import RxSwift

protocol WeatherRepository {
    
    func fetchWeatherInformation(
        cityName text: String
    ) -> Single<TodayWeather>
    
    func fetchWeatherInformation(
        latitude: Double,
        longitude: Double
    ) -> Single<TodayWeather>
}
