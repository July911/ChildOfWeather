import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    // MARK: - Property 
    private let coordinator: SearchViewCoordinator
    private let searchUseCase: CitySearchUseCase
    // MARK: - Initializer
    init(searchUseCase: CitySearchUseCase, coodinator: SearchViewCoordinator) {
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
        let cities = self.searchUseCase.extractCities()
        let filteredCities = input.searchBarText
            .map { (text) -> [City] in
                return self.searchUseCase.search(text ?? "") ?? []
        }
        let combined = filteredCities.flatMap {
            $0.isEmpty ? Observable.of(cities) : Observable.of($0)
        }
        let merge = Observable.merge(dismiss, combined)
        
        let presentDetailView = input.didSelectedCell.do(onNext: { city in
            self.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(cityName: city))
        }).map { _ in }

        return Output(initialCities: merge, presentDetailView: presentDetailView)
    }
}




