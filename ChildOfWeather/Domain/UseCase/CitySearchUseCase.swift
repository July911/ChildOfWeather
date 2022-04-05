import Foundation

final class CitySearchUseCase {
    
    let searchRepository: CitySearchRepository
    
    init(searchRepository: CitySearchRepository) {
        self.searchRepository = searchRepository
    }
}
