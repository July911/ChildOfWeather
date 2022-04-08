import Foundation

final class SearchViewModel {
    
    let coordinator: MainCoordinator
    weak var delegate: SearchViewModelDelegate?
    var filterdResults: [City]?
    private let searchUseCase: CitySearchUseCase
    
    init(searchUseCase: CitySearchUseCase, coodinator: MainCoordinator) {
        self.searchUseCase = searchUseCase
        self.coordinator = coodinator
    }
    
    func listUp(_ text: String? = nil) {
        
        if text == nil {
            self.filterdResults = self.searchUseCase.extractAll()
        } else {
            let cities = self.searchUseCase.search(text ?? "")
            self.filterdResults = cities ?? []
        }
        
        DispatchQueue.main.async {
            self.delegate?.didSearchData()
        }
    }
}

protocol SearchViewModelDelegate: AnyObject {
    
    func didSearchData()
}


