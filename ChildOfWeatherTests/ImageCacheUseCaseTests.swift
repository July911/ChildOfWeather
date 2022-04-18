//
//  ImageCacheUseCaseTests.swift
//  ChildOfWeatherTests
//
//  Created by 조영민 on 2022/04/18.
//

import XCTest
@testable import ChildOfWeather

class ImageCacheUseCaseTests: XCTestCase {
    
    var sut: ImageCacheUseCase?

    override func setUpWithError() throws {
        let imageCacheRepository = DefaultImageProvideRepository()
        let imageCacheUseCase = ImageCacheUseCase(imageProvideRepository: imageCacheRepository)
        sut = imageCacheUseCase
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    
    func test_ImageCacheUseCase_cache를_하였을때_정확한_이름으로_들어간다() {
        let image = UIImage(systemName: "plus")
        let key = UUID().uuidString as NSString
        let data = ImageCacheData(key: key, value: image!)
        
        let imageCacheRepository = DefaultImageProvideRepository()
        let imageCacheUseCase = ImageCacheUseCase(imageProvideRepository: imageCacheRepository)
        
        imageCacheUseCase.setCache(object: data)
        let cachedImage = imageCacheUseCase.fetchImage(cityName: key as String)
        
        XCTAssertEqual(cachedImage?.value, image)
    }

}
