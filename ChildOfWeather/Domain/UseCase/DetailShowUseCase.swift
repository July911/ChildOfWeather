import Foundation

final class DetailShowUseCase {
    
    let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func extractWeather(data city: City, completion: @escaping (Result<[String: Any],dataError>) -> Void) {
        let cityName = city.name

        self.weatherRepository.getDataFromCity(text: cityName, completion: { data in
            guard let weatherInformation = try? JSONSerialization.jsonObject(with: data!) as? [String: Any]
            else {
                completion(.failure(dataError.dataNotCome))
                return
            }
            completion(.success(weatherInformation))
        })
    }
}

enum dataError: Error {
    case dataNotCome
}
