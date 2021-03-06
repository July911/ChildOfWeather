import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    // MARK: - Property 
    private let coordinator: SearchViewCoordinator
    private let searchUseCase: CitySearchUseCase
    // MARK: - Initializer
    init(
        searchUseCase: CitySearchUseCase,
        coodinator: SearchViewCoordinator
    ) {
        self.searchUseCase = searchUseCase
        self.coordinator = coodinator
    }
   // MARK: - Nested Type
    struct Input {
        let viewWillAppear: Observable<Void>
        let didSelectedCell: Observable<City>
        let searchBarText: Observable<String?>
        let viewWillDismiss: Observable<Void>
    }
    
    struct Output {
        let initialCities: Observable<[City]>
        let presentDetailView: Observable<Void>
    }
    // MARK: - Open Method
    func transform(input: Input) -> Output {
        let dismiss = input.viewWillDismiss.map { _ in
            self.searchUseCase.search("") ?? []
        }
        let cities = self.searchUseCase.fetchCities()
        let filteredCities = input.searchBarText
            .map { (text) -> [City] in
                return self.searchUseCase.search(text ?? "") ?? []
            }
            .flatMap {
                $0.isEmpty ? Observable.of(cities) : Observable.of($0)
            }
        let merge = Observable.merge(dismiss, filteredCities)
        
        let presentDetailView = input.didSelectedCell
            .withUnretained(self)
            .do(onNext: { (self,city) in
                self.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(city: city))
            })
            .map { _ in }

        return Output(initialCities: merge, presentDetailView: presentDetailView)
    }
}




