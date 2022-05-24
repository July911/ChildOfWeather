import XCTest
import RxTest
import Nimble
import RxNimble
import RxSwift
@testable import ChildOfWeather

class CitySearchUseCaseTests: XCTestCase {
    
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
}
