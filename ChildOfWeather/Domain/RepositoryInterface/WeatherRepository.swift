import Foundation
import RxSwift

protocol WeatherRepository {
    
    func fetchWeatherInformation(
        cityName text: String
    ) -> Observable<TodayWeather>
    
    func fetchWeatherInformation(
        latitude: Double,
        longitude: Double
    ) -> Observable<TodayWeather>
}
