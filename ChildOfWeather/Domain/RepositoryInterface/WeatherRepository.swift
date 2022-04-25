import Foundation
import RxSwift

protocol WeatherRepository {
    
    func fetchWeatherInformation(
        cityName text: String) -> Observable<TodayWeather>
    
    func fetchURLFromLocation(locationAddress address: String) -> String
}
