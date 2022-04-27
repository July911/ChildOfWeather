import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class SearchViewModel {
    
    private let coordinator: MainCoordinator
    private let searchUseCase: CitySearchUseCase
    private let bag = DisposeBag()
    
    init(searchUseCase: CitySearchUseCase, coodinator: MainCoordinator) {
        self.searchUseCase = searchUseCase
        self.coordinator = coodinator
    }
  
    struct Input {
        let viewWillAppear: Observable<Void>
        let didSelectedCell: Observable<City>
        let searchBarText: Observable<String?>
    }
    
    struct Output {
        let initialCities: Driver<[City]>
//        let filteredCities: Observable<[City]>
    }
    
    func transform(input: Input) -> Output {
        let cities = self.searchUseCase.extractCities().asDriver()

        input.searchBarText.distinctUntilChanged()
            .subscribe(onNext: { text in
                self.searchUseCase.search(text ?? "")
            }).disposed(by: self.bag)
     
        input.didSelectedCell.subscribe(onNext: { (city) in
            self.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(cityName: city))
        }).disposed(by: self.bag)
        
        return Output(initialCities: cities)
    }
}



