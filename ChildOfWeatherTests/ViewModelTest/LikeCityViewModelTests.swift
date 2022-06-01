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
    
    var likeCityViewModel: LikeCityViewModel!
    var output: LikeCityViewModel.Ouput!
    var bag: DisposeBag!
    var scheduler: TestScheduler!
    var viewDidLoda: PublishSubject<Void>!
    var didTappedCell: PublishSubject<IndexPath>!
    
    var detailShowViewModel: DetailWeatherViewModel!
    var capturedPublish: PublishSubject<ImageCacheData>!
    var touchUpBackButtonPublish: PublishSubject<Void>!
    
    
    override func setUp() {
        //MARK: LikeCityViewModel SetUP
        self.bag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        self.likeCityViewModel = LikeCityViewModel(
            citySearchUseCase: CitySearchUseCase(searchRepository: DefaultCitySearchRepository()),
 imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
 weatherUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService()))
        )
        self.viewDidLoda = PublishSubject<Void>()
        self.didTappedCell = PublishSubject<IndexPath>()
        self.output = likeCityViewModel.transform(
            input: .init(viewDidLoad: self.viewDidLoda.asObserver(), didTappedCell: self.didTappedCell.asObserver())
        )
        
        //MARK: detailShowViewModelSetUp
        self.capturedPublish = PublishSubject<ImageCacheData>()
        self.touchUpbackButtonPublish = PublishSubject<Void>()
        self.detailShowViewModel = DetailWeatherViewModel(
            detailShowUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService())),
            imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
            coodinator: SearchViewCoordinator(
                imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository())),
                city: City.EMPTY
            )
            
        self.output = viewModel.transform(input: .init(viewWillAppear: self.viewWillAppearPusblish.asObserver(), capturedImage: self.capturedPublish.asObserver(), touchUpbackButton: self.touchUpbackButtonPublish.asObserver()))
    }
    
    func testemptyCached() {
        self.scheduler.createColdObservable(
        [
            .next(0, ())
        
        ]).bind(to: viewDidLoda).disposed(by: self.bag)
        
        expect(self.output.likedCities).events(scheduler: scheduler, disposeBag: self.bag).to(equal([
            .next(0, [])
        ]))
    }
    
    func testCachedSuccess() {
        let cachedData1 = ImageCacheData(key: "test1", value: UIImage())
        let cachedData2 = ImageCacheData(key: "test2", value: UIImage())
        self.likeCityViewModel.imageCacheUseCase.setCache(object: cachedData1)
        let cityCell = CityCellViewModel(cityName: "test", image: cachedData1, highTemperature: <#T##Double#>, lowTemperature: <#T##Double#>)
        scheduler.createColdObservable([
            .next(0, cityCell)
        ]).bind(to: self.)
        
        expect(self.output.likedCities).events(scheduler: scheduler, disposeBag: self.bag).to(equal([
            .next(0, cityCell)
        ]))
    }
    

    
    
}
