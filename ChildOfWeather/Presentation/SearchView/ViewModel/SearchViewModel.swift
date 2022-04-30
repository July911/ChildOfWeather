import Foundation
import RxSwift
import RxRelay

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
        let initialCities: Observable<[City]>
    }
    // MARK: - Open Method
    func transform(input: Input) -> Output {
        let entireCities = self.searchUseCase.extractCities().asObservable()
        let filteredCities = input.searchBarText.distinctUntilChanged()
            .flatMap { (text) -> Observable<[City]> in
            return self.searchUseCase.search(text ?? "")
        }

        let combined = filteredCities.flatMap {
            $0.isEmpty ? entireCities : Observable.of($0)
        }
        
        input.didSelectedCell.subscribe(onNext: { (city) in
            self.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(cityName: city))
        }).disposed(by: self.bag)
        
        return Output(initialCities: combined)
    }
}




