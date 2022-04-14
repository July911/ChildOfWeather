import Foundation

final class SearchViewModel: SearchViewViewModelProtocol {
    
    var filterdResults: [City]? 
    weak var delegate: SearchViewModelDelegate?
    private let coordinator: MainCoordinator
    private let searchUseCase: CitySearchUseCase
    
    init(searchUseCase: CitySearchUseCase, coodinator: MainCoordinator) {
        self.searchUseCase = searchUseCase
        self.coordinator = coodinator
    }
    
    func configureLoactionLists(_ text: String? = nil) {
        
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
    
    func occuredCellTapEvent(city: City) {
        self.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(cityName: city))
    }
}

protocol SearchViewModelDelegate: AnyObject {
    
    func didSearchData()
}


