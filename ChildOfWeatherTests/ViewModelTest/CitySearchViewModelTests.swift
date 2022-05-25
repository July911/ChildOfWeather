//
//  CitySearchViewModelTests.swift
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
//
//    func testSearchBarText() {
//
//        schduler.createColdObservable(
//        [.next(10, ()),
//            .next(20, ()),
//            .next(30, ())
//        ]
//    ).bind(to: plusSubject).disposed(by: disposeBag)
//
//    scheduler.createColdObservable(
//        [
//            .next(25, ())
//        ]
//    ).bind(to: subtractSubject).disposed(by: disposeBag)
//
//    expect(self.output.countedValue).events(scheduler: scheduler, disposeBag: disposeBag).to(equal(
//        [
//            .next(0, 0),
//            .next(10, 1),
//            .next(20, 2),
//            .next(25, 1),
//            .next(30, 2)
//        ]
//    ))
}


