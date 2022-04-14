import Foundation

final class DefaultWeatherRepository: WeatherRepository {
    
    let service: APIService
    
    init(service: APIService) {
        self.service = service
    }
    
    func fetchWeatherInformation(
        cityName text: String,
        completion: @escaping (TodayWeather?) -> Void
    ) {
        let request: RequestType = .getWeatherFromCityName(city: text)
        
        service.request(decodedType: WeatherInformation.self, requestType: request) { result in
            switch result {
            case .success(let weatherInformation):
                let todayWeather = weatherInformation.toDomain()
                completion(todayWeather)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func fetchURLFromLoaction(locationAddress address: String) -> String {
        let type: RequestType = .getMapfromLocationInformation(location: address)
        
        return type.fullURL
    }

}
