import Foundation

final class DetailShowUseCase {
    
    let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
//    func extractWeather(data city: City) -> Result<WeatherInfomation,Error> {
//        let cityName = city.name
//
//        guard let data = self.weatherRepository.getDataFromCity(text: cityName)
//        else {
//            return .failure(error?.localizedDescription)
//        }
//    }
}
