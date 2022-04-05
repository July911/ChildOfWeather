import Foundation

final class CitySearchUseCase {
    
    let searchRepository: CitySearchRepository
    
    init(searchRepository: CitySearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func search(_ string: String) -> [City]? {
        self.searchRepository.search(name: string) ?? []
    }
    
    func extractAll() -> [City] {
        self.searchRepository.assetData ?? []
    }
}
