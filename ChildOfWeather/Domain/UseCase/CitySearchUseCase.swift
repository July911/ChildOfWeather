import Foundation

final class CitySearchUseCase {
    
    private let searchRepository: CitySearchRepository
    
    init(searchRepository: CitySearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func search(_ string: String) -> [City]? {
        self.searchRepository.search(name: string)
    }
    
    func fetchCities() -> [City] {
        self.searchRepository.extractCities(by: .kr)
    }
}
