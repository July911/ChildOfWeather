import Foundation

final class DefaultWeatherRepository: WeatherRepository {
    
    let service: APIService<WeatherInformation>
    
    init(service: APIService<WeatherInformation>) {
        self.service = service
    }
    
    func getWeatherInformation(cityName text: String, completion: @escaping (TodayWeather?) -> Void) {
        let request: RequestType = .getWeatherFromCityName(city: text)
        
        service.request(request) { result in
            switch result {
            case .success(let weatherInformation):
                let todayWeather = weatherInformation.toDomain()
#if DEBUG
                print("weatherInformation: \(weatherInformation)")
                print("todayWeather: \(todayWeather)")
#endif
                completion(todayWeather)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func getURLFromLoaction(locationAdress adress: String) -> String {
        let type: RequestType = .getMapfromLocationInformation(location: adress)
        
        return type.fullURL
    }

}
