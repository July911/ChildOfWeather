import Foundation

final class SearchViewModel {
    
    private let searchUseCase: CitySearchUseCase
    private let coordinator: MainCoordinator
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

extension SearchViewModel: SearchViewControllerDelegate {
    func searchViewController(_ viewController: SearchViewController, textInput text: String) {
        let results = self.searchUseCase.search(text)
        self.filterdResults = self.listUp(results)
    }
    
    func searchViewController(_ viewController: SearchViewController, didSelectCell infomation: City) {
    }
}
