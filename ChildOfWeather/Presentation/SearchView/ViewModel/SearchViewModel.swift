import Foundation

final class SearchViewModel {
    
    let searchUseCase: CitySearchUseCase
    let coordinator: MainCoordinator
    
    init(searchUseCase: CitySearchUseCase, coodinator: MainCoordinator) {
        self.searchUseCase = searchUseCase
        self.coordinator = coodinator
    }
    
    func listUp() -> [City] {
        []
    }
}

extension SearchViewModel: SearchViewControllerDelegate {
    func SearchViewController(_ viewController: SearchViewController, didSelectCell infomation: City) {
    }
}
