import Foundation

protocol WeatherRepository {
    
    func getDataFromCity(text: String) -> Data?
    
    func getURLFromLoaction(text: String) -> String
    
}
