import Foundation

final class SearchViewModel {
    
    let searchUseCase: CitySearchUseCase
    
    init(searchUseCase: CitySearchUseCase) {
        self.searchUseCase = searchUseCase
    }
    
    func listUp() -> [City] {
        []
    }
}
