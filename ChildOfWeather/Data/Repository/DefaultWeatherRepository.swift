import Foundation
import RxSwift

final class DefaultWeatherRepository: WeatherRepository {
    
    private let service: URLSessionNetworkService
    
    init(service: URLSessionNetworkService) {
        self.service = service
    }
    
    func fetchWeatherInformation(
        cityName text: String) -> Observable<TodayWeather>
    {
        let param = CityWeatherRequestParams(city: text)
        let request = CityWeatherRequest(method: .GET, params: param)

        return self.service.requestRx(request: request).map { $0.toDomain() }
    }
    
    func fetchWeatherInformation(latitude: Double, longitude: Double) -> Observable<TodayWeather> {
        let param = CoordinateWeatherRequestParams(latitude: latitude, longitude: longitude)
        let request = CoordinateWeatherRequest(method: .GET, params: param)
        
        return self.service.requestRx(request: request).map { $0.toDomain() }
    }
}
