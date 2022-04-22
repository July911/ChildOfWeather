import Foundation
import RxSwift

protocol WeatherRepository {
    
    func fetchWeatherInformation(
        cityName text: String) -> Observable<TodayWeather>
    
    func fetchURLFromLoaction(locationAddress address: String) -> String
}
