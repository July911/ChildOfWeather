import Foundation

protocol WeatherRepository {
    func getDataFromCity(text: String) -> Data?
}
