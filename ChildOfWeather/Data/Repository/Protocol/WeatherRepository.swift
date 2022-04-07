import Foundation

protocol WeatherRepository {
    
    func getDataFromCity(text: String, completion: @escaping (Data?) -> Void)

    func getURLFromLoaction(text: String) -> String
}
