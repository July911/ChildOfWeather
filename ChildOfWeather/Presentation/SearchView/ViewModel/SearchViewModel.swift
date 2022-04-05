import Foundation

final class SearchViewModel {
    
    private let searchUseCase: CitySearchUseCase
    private let coordinator: MainCoordinator
    weak var delegate: SearchViewModelDelegate?
    var filterdResults: [City]?
    
    init(searchUseCase: CitySearchUseCase, coodinator: MainCoordinator) {
        self.searchUseCase = searchUseCase
        self.coordinator = coodinator
    }
    
    func listUp(_ lists: [City]? = nil) -> [City] {
        
        if lists == nil {
            return self.searchUseCase.extractAll()
        } else {
            return lists ?? []
        }
    }
}

protocol SearchViewModelDelegate: AnyObject {
    
}


