import XCTest
@testable import ChildOfWeather

class ChildOfWeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_CitySearchUseCase_아무것도_입력하지_않았을때_데이터를_전부_받아온다() {
        let cityRepository = DefaultCitySearchRepository()
        let cities = cityRepository.sortCity().count
        let cityfromKr = cityRepository.sortCity(by: .kr).count
        
        XCTAssertEqual(cities, cityfromKr)
    }
    
    func test_CitySearchUseCase_yongin을_search했을때_값은_yongin이다() {
        let cityRepository = DefaultCitySearchRepository()
        let city = cityRepository.search(name: "yong")?.first
        let cityName = city?.name
        
        XCTAssertEqual(cityName!, "Yongin")
    }
    
    func test_DataLayer의_DTO인_WeatherInformation이_Model로_정상적으로_변환된다() {
        let main = Main(temp: 32, maxTemperature: 35, minTemperature: 28)
        let sys = Sys(sunrise: 14, sunset: 2)
        let weather = Weather(description: "", id: 1)
        let weatherInformation = WeatherInformation(name: "이매동", main: main, weather: [weather], sys: sys)
        
        let weatherFromEntity = weatherInformation.toDomain()
        
        XCTAssertEqual(weatherInformation.sys.sunset, weatherFromEntity.sunset)
        XCTAssertEqual(weatherInformation.sys.sunrise, weatherFromEntity.sunrise)
        XCTAssertEqual(weatherInformation.main.maxTemperature, weatherFromEntity.maxTemperature)
        XCTAssertEqual(weatherInformation.main.minTemperature, weatherFromEntity.minTemperature)
    }
    
    func test_ImageCacheUseCase_cache를_하였을때_정확한_이름으로_들어간다() {
        let image = UIImage(systemName: "plus")
        let key = UUID().uuidString as NSString
        let data = ImageCacheData(key: key, value: image!)
        
        let imageCacheRepository = DefaultImageProvideRepository()
        let imagaCacheUseCase = ImageCacheUseCase(imageProvideRepository: imageCacheRepository)
        
        imagaCacheUseCase.setCache(object: data)
        let cachedImage = imagaCacheUseCase.fetchImage(cityName: key as String)
        
        XCTAssertEqual(cachedImage?.value, image)
    }
    
    func test_AddressSearchUseCase_이매동_위경도를_입력했을때_이매동_주소가_나온다() {
        let imaelatitude = 37.39508700000
        let imaelongitude = 127.12415500000
        let addressSearchRepository = DefaultAddressSearchRepository()
        let addressSearchUseCase = AddressSearchUseCase(addressRepository: addressSearchRepository)
        
        let promise = expectation(description: "")
        addressSearchUseCase.searchLocation(latitude: imaelatitude, longitude: imaelongitude) { (address) in
            XCTAssertEqual(address!, "153-2 Imae-dong")
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 3)
    }
}
