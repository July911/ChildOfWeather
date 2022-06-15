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
    
    //MARK: Share
    var bag: DisposeBag!
    var scheduler: TestScheduler!
    //MARK: LikeCityViewModel Components
    var likeCityViewModel: LikeCityViewModel!
    var likcCityViewModeloutput: LikeCityViewModel.Ouput!
    var viewDidLoad: PublishSubject<Void>!
    var didTappedCell: PublishSubject<IndexPath>!
    //MARK: DetailViewModel To Change CacheCities
    var detailShowViewModel: DetailWeatherViewModel!
    var capturedPublish: PublishSubject<ImageCacheData>!
    var touchUpBackButtonPublish: PublishSubject<Void>!
    var detailViewModelOutput: DetailWeatherViewModel.Output!
    var viewWillAppearPublish: PublishSubject<Void>!
    
    override func setUp() {
        //MARK: LikeCityViewModel SetUP
        self.bag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        self.likeCityViewModel = LikeCityViewModel(
            citySearchUseCase: CitySearchUseCase(searchRepository: DefaultCitySearchRepository()),
 imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
 weatherUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService()))
        )
        self.viewDidLoad = PublishSubject<Void>()
        self.didTappedCell = PublishSubject<IndexPath>()
        self.likcCityViewModeloutput = likeCityViewModel.transform(
            input: .init(viewDidLoad: self.viewDidLoad.asObserver(),
                         didTappedCell: self.didTappedCell.asObserver())
        )
        
        //MARK: detailShowViewModelSetUp
        self.capturedPublish = PublishSubject<ImageCacheData>()
        self.touchUpBackButtonPublish = PublishSubject<Void>()
        self.viewWillAppearPublish = PublishSubject<Void>()
        self.touchUpBackButtonPublish = PublishSubject<Void>()
        self.detailShowViewModel = DetailWeatherViewModel(
            detailShowUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService())),
            imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
            coodinator: SearchViewCoordinator(
                imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository())),
                city: City.EMPTY
            )
            
        self.detailViewModelOutput = detailShowViewModel.transform(
            input: .init(viewWillAppear: self.viewWillAppearPublish.asObservable(),
                         capturedImage: self.capturedPublish.asObservable(),
                         touchUpbackButton: self.touchUpBackButtonPublish.asObservable())
        )
    }
    
    func testemptyCached() {
        self.scheduler.createColdObservable(
        [
            .next(0, ())
        
        ]).bind(to: viewDidLoad).disposed(by: self.bag)
        
        expect(self.likcCityViewModeloutput.likedCities).events(scheduler: scheduler, disposeBag: self.bag).to(equal([
            .next(0, [])
        ]))
    }

    func testCachedSuccess() {
        let cachedData1 = ImageCacheData(key: "test1", value: UIImage())
        let cachedData2 = ImageCacheData(key: "test2", value: UIImage())
        self.likeCityViewModel.imageCacheUseCase.setCache(object: cachedData1)
        let cityCell = CityCellViewModel(cityName: "test", image: cachedData1, highTemperature: 120.0, lowTemperature: 60.0)

        scheduler.createColdObservable([
            .next(0, cachedData1)
        ]).bind(to: self.capturedPublish).disposed(by: self.bag)

        expect(self.likcCityViewModeloutput.likedCities).events(scheduler: self.scheduler, disposeBag: self.bag).to(equal([
            .next(0, [cityCell])
        ]))
    }
}
