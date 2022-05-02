import Foundation

protocol CitySearchRepository {
        
    func search(name: String?) -> [City]?
    
    func extractCities(by country: Country) -> [City]
}
