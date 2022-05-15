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
        let param = CoordinateWeatherRequestParams(latitude: <#T##Int#>, longitude: <#T##Int#>)
        let request = CoordinateWeatherRequest(method: .GET, params: <#T##QueryParameters#>, urlString: <#T##String#>)
        
        return self.service.requestRx(decodedType: WeatherInformation.self, requestType: request)
            .map { $0.toDomain() }
    }
    
    func fetchWeatherInformation(latitude: Double, longitude: Double) -> Observable<TodayWeather> {
        let param = CoordinateWeatherRequestParams(latitude: latitude, longitude: longitude)
        let request = CoordinateWeatherRequest(method: .GET, params: param)
        
        return self.service.requestRx(request: request).map { $0.toDomain() }
    }
}
