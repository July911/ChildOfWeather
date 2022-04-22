import Foundation
import RxSwift

final class DefaultWeatherRepository: WeatherRepository {
    
    let service: URLSessionNetworkService
    private let bag = DisposeBag()
    
    init(service: URLSessionNetworkService) {
        self.service = service
    }
    
    func fetchWeatherInformation(
        cityName text: String) -> Observable<TodayWeather>
    {
        let request: RequestType = .getWeatherFromCityName(city: text)
        
        return Observable<TodayWeather>.create { emitter in
            self.service.request(decodedType: WeatherInformation.self, requestType: request).subscribe { (result) in
                switch result {
                case .success(let weatherInformation):
                    emitter.onNext(weatherInformation.toDomain())
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: self.bag)
            
            return Disposables.create()
        }
    }
    
    
    func fetchURLFromLoaction(locationAddress address: String) -> String {
        let type: RequestType = .getMapfromLocationInformation(location: address)
        
        return type.fullURL
    }

}
