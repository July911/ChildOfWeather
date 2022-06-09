//
//  LikeCityViewModelTests.swift
//  ChildOfWeatherTests
//
//  Created by 조영민 on 2022/05/25.
//

import XCTest
import RxNimble
import Nimble
import RxSwift
import RxTest

@testable import ChildOfWeather

class CurrentLocationViewModelTests: XCTestCase {
    
    var viewModel: CurrentLocationViewModel!
    var output: CurrentLocationViewModel.Output!
    var bag: DisposeBag!
    var scheduler: TestScheduler!
    var viewWillAppear: PublishSubject<Void>!
    var cachedImage: PublishSubject<ImageCacheData>!
    var locationChange: PublishSubject<Void>!
    var dismiss: PublishSubject<Void>!
    
    override func setUp() {
        self.viewModel = CurrentLocationViewModel(
            detailShowUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService())),
            imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
            coordinator: CurrentLocationCoordinator(imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()))
        )
        self.bag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        self.viewWillAppear = PublishSubject<Void>()
        self.cachedImage = PublishSubject<ImageCacheData>()
        self.locationChange = PublishSubject<Void>()
        self.dismiss = PublishSubject<Void>()
        self.output = self.viewModel.transform(
            input: .init(viewWillAppear: self.viewWillAppear.asObserver(), cachedImage: self.cachedImage.asObserver(), locationChange: self.locationChange.asObserver(), dismiss: self.dismiss.asObserver())
        )
    }
    
    func testCacheSuccess() {
        let imageCacheData = ImageCacheData(key: "123", value: UIImage())
        scheduler.createColdObservable([
            .next(0, ())
        ]).bind(to: viewWillAppear).disposed(by: self.bag)
        
        expect(self.output.currentImage).events(scheduler: self.scheduler, disposeBag: self.bag).to(equal([
            .next(0, imageCacheData)
        ]))
    }
    
    func testCaptureWhenDismiss() {
        let imageCacheData = ImageCacheData(key: "123", value: UIImage())
        // MARK: - Capture Current Location
        scheduler.createColdObservable([
            .next(0, ())
        ]).bind(to: viewWillAppear).disposed(by: self.bag)
        
        expect(self.output.currentImage).events(scheduler: self.scheduler, disposeBag: self.bag).to(equal([
            .next(0, imageCacheData)
        ]))
        // MARK: - Cache Check
        scheduler.createColdObservable([
            .next(0, ())
        ]).bind(to: self.dismiss).disposed(by: self.bag)
        
        expect(self.output.isImageCached).events(scheduler: self.scheduler, disposeBag: self.bag).to(equal([
            .next(0, true)
        ]))
    }
    
    func testLocationchangebuttonTapped() {
        scheduler.createColdObservable([
            .next(0, ())
        ]).bind(to: self.locationChange).disposed(by: self.bag)
        
        expect(self.output.isImageCached.asObservable()).events(scheduler: self.scheduler, disposeBag: self.bag).to(equal([
            .next(1, false)
        ]))
    }
}
