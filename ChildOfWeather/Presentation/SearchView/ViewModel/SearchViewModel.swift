import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class SearchViewModel {
    // MARK: - Property 
    private let coordinator: MainCoordinator
    private let searchUseCase: CitySearchUseCase
    private let bag = DisposeBag()
    // MARK: - Initializer
    init(searchUseCase: CitySearchUseCase, coodinator: MainCoordinator) {
        self.searchUseCase = searchUseCase
        self.coordinator = coodinator
    }
   // MARK: - Nested Type
    struct Input {
        let viewWillAppear: Observable<Void>
        let didSelectedCell: Observable<City>
        let searchBarText: Observable<String?>
    }
    
    struct Output {
        let initialCities: Driver<[City]>
    }
    // MARK: - Open Method
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



