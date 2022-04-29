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
        
        self.sut?.setCache(object: data)
        let cachedImage = self.sut?.fetchImage(cityName: key as String)
        
        XCTAssertEqual(cachedImage?.value, image)
    }
    
    func test_ImageCache를_하지않은_상태에서_check를하면_false가_나온다() {
        let isCached = sut?.hasCacheExist(cityName: "imae")
        
        XCTAssertEqual(false, isCached)
    }
}
