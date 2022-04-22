import Foundation
import RxRelay

protocol CitySearchRepository {
        
    func search(name: String)
    
    func sortCity(by country: Country) -> BehaviorRelay<[City]>
}
