//
//  DetailShowViewModelTests.swift
//  ChildOfWeatherTests
//
//  Created by 조영민 on 2022/05/25.
//
import XCTest
import RxTest
import Nimble
import RxNimble
import RxSwift

@testable import ChildOfWeather

class DetailShowUseCaseTests: XCTestCase {
    
    var viewModel: DetailWeatherViewModel!
    var output: DetailWeatherViewModel.Output!
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
        self.viewModel = DetailWeatherViewModel(
            detailShowUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService())),
            imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
            coodinator: SearchViewCoordinator(
                imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
                city: ""
            )
            )
        self.output = viewModel.transform(input: .init(viewWillAppear: <#T##Observable<Void>#>, capturedImage: <#T##Observable<ImageCacheData>#>, touchUpbackButton: <#T##Observable<Void>#>))
    }
}
