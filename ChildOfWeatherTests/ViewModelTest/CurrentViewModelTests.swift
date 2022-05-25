//
//  CurrentViewModelTests.swift
//  ChildOfWeatherTests
//
//  Created by 조영민 on 2022/05/25.
//
import RxTest
import Nimble
import RxNimble
import XCTest
import RxSwift

@testable import ChildOfWeather

class LikeCityViewModelTests: XCTestCase {
    
    var viewModel: LikeCityViewModel!
    var output: LikeCityViewModel.Ouput!
    var bag: DisposeBag!
    var scheduler: TestScheduler!
    var viewDidLoda: PublishSubject<Void>!
    var didTappedCell: PublishSubject<IndexPath>!
    
    override func setUp() {
        self.bag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        self.viewModel = LikeCityViewModel(
            citySearchUseCase: CitySearchUseCase(searchRepository: DefaultCitySearchRepository()),
 imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
 weatherUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService()))
        )
        self.viewDidLoda = PublishSubject<Void>()
        self.didTappedCell = PublishSubject<IndexPath>()
        self.output = viewModel.transform(
            input: .init(viewDidLoad: self.viewDidLoda.asObserver(), didTappedCell: self.didTappedCell.asObserver())
        )
    }
    
    
}
