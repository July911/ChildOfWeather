import Foundation

final class DefaultWeatherRepository: WeatherRepository {
    
    let service: URLSessionNetworkService
    
    init(service: URLSessionNetworkService) {
        self.service = service
    }
    
    func getDataFromCity(text: String, completion: @escaping (Data?) -> Void) {
        let request: RequestType = .getWeatherFromCityName(city: text)
        
        service.request(request) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let _):
                completion(nil)
            }
        }
    }
    
    func getURLFromLoaction(text: String) -> String {
        let type: RequestType = .getMapfromLocationInformation(location: text)
        
        return type.fullURL
    }

}
