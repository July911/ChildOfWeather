import Foundation

final class DefaultWeatherRepository: WeatherRepository {
    
    let service: URLSessionNetworkService
    
    init(service: URLSessionNetworkService) {
        self.service = service
    }
    
    func getDataFromCity(text: String) -> Data? {
        let request: RequestType = .getWeatherFromCityName(city: text)
        var resultData: Data?
        
        service.request(request) { result in
            switch result {
            case .success(let data):
                resultData = data
            case .failure(let _):
                resultData = Data()
            }
        }
        
        return resultData
    }
    
    func getURLFromLoaction(text: String) -> String {
        
        let type: RequestType = .getMapfromLocationInformation(location: text)
        return type.fullURL
    }

}
