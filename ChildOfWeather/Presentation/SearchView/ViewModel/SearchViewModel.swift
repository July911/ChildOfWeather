import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    
    var filterdResults: [City]? 
    private let coordinator: MainCoordinator
    private let searchUseCase: CitySearchUseCase
    
    init(searchUseCase: CitySearchUseCase, coodinator: MainCoordinator) {
        self.searchUseCase = searchUseCase
        self.coordinator = coodinator
    }
  
    struct Input {
        let viewWillAppear: Observable<Void>
        let didSelectedCell: Observable<City>
    }
    
    struct Output {
        let cityInformation: Observable<[City]>
    }
    
    func configureLoactionLists(_ text: String? = nil) {
        
        if text == nil {
            
        } else {
//            let cities = self.searchUseCase.search(text ?? "")
//            self.filterdResults = cities ?? []
        }
        
        DispatchQueue.main.async {
            self.delegate?.didSearchData()
        }
    }
    
    func occuredCellTapEvent(city: City) {
        self.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(cityName: city))
    }
    
    func transform(input: Input) -> Output {
        <#code#>
    }
}



