import Foundation
import RxSwift

final class DefaultWeatherRepository: WeatherRepository {
    
    private let service: URLSessionNetworkService
    
    init(service: URLSessionNetworkService) {
        self.service = service
    }
    
    func fetchWeatherInformation(
        cityName text: String) -> Single<TodayWeather> 
    {
        let request: RequestType = .getWeatherFromCityName(city: text)
        
        return self.service.request(decodedType: WeatherInformation.self, requestType: request)
            .map { $0.toDomain() }
    }
    
    func fetchWeatherInformation(latitude: Double, longitude: Double) -> Single<TodayWeather> {
        let request: RequestType = .getWeatherFromLocation(latitude: latitude, longitude: longitude)
        
        return self.service.request(decodedType: WeatherInformation.self, requestType: request)
            .map { $0.toDomain() }
    }
}
