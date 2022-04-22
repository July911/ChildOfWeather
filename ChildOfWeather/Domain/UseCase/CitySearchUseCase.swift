import Foundation
import RxRelay

final class CitySearchUseCase {
    
    private let searchRepository: CitySearchRepository
    
    init(searchRepository: CitySearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func search(_ string: String) {
        self.searchRepository.search(name: string)
    }
    
    func extractCities() -> BehaviorRelay<[City]> {
        self.searchRepository.extractCities(by: .kr)
    }
}
