import Foundation
import RxSwift

final class DefaultWeatherRepository: WeatherRepository {
    
    private let service: URLSessionNetworkService
    private let bag = DisposeBag()
    
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
    
    func fetchURLFromLocation(locationAddress address: String) -> String {
        let type: RequestType = .getMapfromLocationInformation(location: address)
        
        return type.fullURL
    }

}
