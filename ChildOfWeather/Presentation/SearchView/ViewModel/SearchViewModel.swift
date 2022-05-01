import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    // MARK: - Property 
    private let coordinator: MainCoordinator
    private let searchUseCase: CitySearchUseCase
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
        let presentDetailView: Observable<Void>
    }
    // MARK: - Open Method
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let cities = self.searchUseCase.extractCities()
        let filteredCities = input.searchBarText.distinctUntilChanged()
            .flatMap { (text) -> Observable<[City]> in
            return self.searchUseCase.search(text ?? "")
        }
        let combined = filteredCities.flatMap {
            $0.isEmpty ? Observable.of(cities) : Observable.of($0)
        }
        let citiesCombinedInputEvent = combined.sample(input.viewWillAppear)

        let presentDetailView = input.didSelectedCell.do(onNext: { city in
            self.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(cityName: city))
        }).map { _ in }
            
        return Output(initialCities: citiesCombinedInputEvent, presentDetailView: presentDetailView)
    }
}




