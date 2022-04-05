import Foundation

final class DefaultWeatherRepository: WeatherRepository {
    
    let service: URLSessionNetworkService
    
    init(service: URLSessionNetworkService) {
        self.service = service
    }
}
