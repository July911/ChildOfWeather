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
    }
    
    func transform(input: Input) -> Output {
        let entireCities = self.searchUseCase.extractCities().asObservable()
        let filteredCities = input.searchBarText.distinctUntilChanged()
            .flatMap { (text) -> Observable<[City]> in
            return self.searchUseCase.search(text ?? "")
        }

        let combined = Observable.combineLatest(entireCities, filteredCities) { (city, fil) -> [City] in
            return fil.isEmpty ? city : fil
        }.asDriver(onErrorJustReturn: [])
        
     
     
        input.didSelectedCell.subscribe(onNext: { (city) in
            self.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(cityName: city))
        }).disposed(by: self.bag)
        
        return Output(initialCities: combined)
    }
}



