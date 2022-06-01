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

class DetailShowViewModelTests: XCTestCase {
    
    var viewModel: DetailWeatherViewModel!
    var output: DetailWeatherViewModel.Output!
    var schduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewWillAppearPusblish: PublishSubject<Void>!
    var capturedPublish: PublishSubject<ImageCacheData>!
    var touchUpbackButtonPublish: PublishSubject<Void>!
    var scheduler: TestScheduler!
    
    override func setUp() {
        self.schduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.capturedPublish = PublishSubject<ImageCacheData>()
        self.viewWillAppearPusblish = PublishSubject<Void>()
        self.touchUpbackButtonPublish = PublishSubject<Void>()
        self.schduler = TestScheduler(initialClock: 0)
        self.viewModel = DetailWeatherViewModel(
            detailShowUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService())),
            imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
            coodinator: SearchViewCoordinator(
                imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository())),
                city: City.EMPTY
            )
            
        self.output = viewModel.transform(input: .init(viewWillAppear: self.viewWillAppearPusblish.asObserver(), capturedImage: self.capturedPublish.asObserver(), touchUpbackButton: self.touchUpbackButtonPublish.asObserver()))
    }
    
    func testCapturedImage() {
        let imageCachedData = ImageCacheData(key: "123", value: UIImage())
        schduler.createColdObservable([
            .next(3, imageCachedData)
        ]).bind(to: self.capturedPublish).disposed(by: self.disposeBag)
        
        expect(self.output.cachedImage).events(scheduler: scheduler, disposeBag: self.disposeBag).to(equal([
            .next(4, imageCachedData)
        ]))
    }
    
    func testBackButtonRunDismiss() {
        scheduler.createColdObservable([
            .next(5, ())
        ]).bind(to: self.touchUpbackButtonPublish).disposed(by: self.disposeBag)
        
        expect(self.output.dismiss).events(scheduler: self.scheduler, disposeBag: self.disposeBag).to(equal([
            .next(5, ())
        ]))
    }
}
