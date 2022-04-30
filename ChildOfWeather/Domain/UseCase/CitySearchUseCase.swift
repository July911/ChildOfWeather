import Foundation
import RxRelay
import RxSwift

final class CitySearchUseCase {
    
    private let searchRepository: CitySearchRepository
    
    init(searchRepository: CitySearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func search(_ string: String) -> Observable<[City]> {
        self.searchRepository.search(name: string)
    }
    
    func extractCities() -> [City] {
        self.searchRepository.extractCities(by: .kr)
    }
}
