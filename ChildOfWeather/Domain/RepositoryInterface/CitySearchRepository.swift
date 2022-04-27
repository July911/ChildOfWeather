import Foundation
import RxRelay
import RxSwift

protocol CitySearchRepository {
        
    func search(name: String?) -> Observable<[City]>
    
    func extractCities(by country: Country) -> BehaviorRelay<[City]>
}
