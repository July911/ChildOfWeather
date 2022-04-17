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
}
