import Foundation

final class DetailShowUseCase {
    
    let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func extractWeather(data city: City, completion: @escaping (Result<WeatherInformation,dataError>) -> Void) {
        let cityName = city.name

        self.weatherRepository.getDataFromCity(text: cityName, completion: { data in
            print(data)
            guard let weatherInformation = try? JSONDecoder().decode(WeatherInformation.self, from: data ?? Data())
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
