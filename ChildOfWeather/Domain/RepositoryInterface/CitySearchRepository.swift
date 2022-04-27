import Foundation
import RxRelay

protocol CitySearchRepository {
        
    func search(name: String?) 
    
    func extractCities(by country: Country) -> BehaviorRelay<[City]>
}
