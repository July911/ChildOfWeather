import Foundation

protocol CitySearchRepository {
        
    func search(name: String) -> [City]?
    
    func sortCity(by country: Country) -> [City]
}
