import XCTest
import RxTest
import Nimble
import RxNimble
import RxSwift

@testable import ChildOfWeather

class CitySearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var output: SearchViewModel.Output!
    var schduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewWillAppearPusblish: PublishSubject<Void>!
    var cellClickPublish: PublishSubject<City>!
    var searchBarTextPublish: PublishSubject<String?>!
    var viewWillDismissPublish: PublishSubject<Void>!
    
    override func setUp() {
        self.schduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.cellClickPublish = PublishSubject<City>()
        self.viewWillAppearPusblish = PublishSubject<Void>()
        self.viewWillDismissPublish = PublishSubject<Void>()
        self.searchBarTextPublish = PublishSubject<String?>()
        self.viewModel = SearchViewModel(
            searchUseCase: CitySearchUseCase(searchRepository: DefaultCitySearchRepository()), coodinator: SearchViewCoordinator(imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()))
        )
        self.output = viewModel.transform(input: .init(
            viewWillAppear: self.viewWillAppearPusblish.asObserver(),
            didSelectedCell: self.cellClickPublish.asObserver(),
            searchBarText: self.searchBarTextPublish.asObserver(),
            viewWillDismiss: self.viewWillDismissPublish.asObserver())
        )
    }
    
    func testSearchBarText() {
        schduler.createColdObservable([
            .next(0, ())
        ]).bind(to: self.viewWillAppearPusblish).disposed(by: self.disposeBag)
        
        schduler.createColdObservable([
            .next(0, "독산리")
        ]).bind(to: searchBarTextPublish).disposed(by: self.disposeBag)
        
        expect(self.output.initialCities.map { $0.count }).events(scheduler: schduler, disposeBag: self.disposeBag).to(equal([
            .next(0, 1)
        ]))
    }
    
    func testPresentView() {
        schduler.createColdObservable([
            .next(0, ())
        ]).bind(to: self.viewWillAppearPusblish).disposed(by: self.disposeBag)
        
        schduler.createColdObservable([
            .next(0, City(id: 1, name: "", state: nil, country: "123", coord: Coord(lat: 12, lon: 33)))
        ]).bind(to: self.cellClickPublish).disposed(by: self.disposeBag)
        
        expect(self.output.presentDetailView).events(scheduler: schduler, disposeBag: self.disposeBag).to(equal([
            .next(0, ())
        ]))
    }
    
    func testFetchAllData() {
        schduler.createColdObservable([
            .next(0, ())
        ]).bind(to: viewWillAppearPusblish).disposed(by: self.disposeBag)
        
        expect(self.output.initialCities.map { $0.count }).events(scheduler: schduler, disposeBag: self.disposeBag).to(equal([
            .next(0, 245)
        ]))
    }
}


