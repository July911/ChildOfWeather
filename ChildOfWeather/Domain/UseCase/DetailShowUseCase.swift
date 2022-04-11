import Foundation

final class DetailShowUseCase {
    
    let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func extractWeather(data city: City, completion: @escaping (Result<Weather,dataError>) -> Void) {
        let cityName = city.name
        
        self.weatherRepository.getDataFromCity(text: cityName, completion: { data in
            
            guard let data = data
            else {
                return
            }
            
            guard let weatherInformation = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else {
                completion(.failure(dataError.dataNotCome))
                return
            }
            
            guard let weather = Weather(data: weatherInformation)
            else {
                completion(.failure(dataError.dataNotCome))
                return
            }
            
            completion(.success(weather))
        })
    }
}

enum dataError: Error {
    case dataNotCome
}
