//import XCTest
//@testable import ChildOfWeather
//
//class CitySearchUseCaseTests: XCTestCase {
//    
//    var sut: CitySearchUseCase?
//
//    override func setUpWithError() throws {
//        let cityRepository = DefaultCitySearchRepository()
//        sut = CitySearchUseCase(searchRepository: cityRepository)
//    }
//    
//    override func tearDownWithError() throws {
//        sut = nil
//    }
//    
//    func test_CitySearchUseCase_아무것도_입력하지_않았을때_데이터를_전부_받아온다() {
//        let cities = self.sut?.extractAll().count
//        let repository = DefaultCitySearchRepository()
//        
//        let cityfromKr = repository.sortCity(by: .kr).count
//        
//        XCTAssertEqual(cities, cityfromKr)
//    }
//    
//    func test_CitySearchUseCase_yongin을_search했을때_값은_yongin이다() {
//        let city = self.sut?.search("yong")?.first
//        let cityName = city?.name
//        
//        XCTAssertEqual(cityName!, "Yongin")
//    }
//    
//    func test_존재하지_않는_도시명을_검색하면_nil이_나온다() {
//        let city = self.sut?.search("London")?.first
//        let cityName = city?.name
//        
//        XCTAssertNil(cityName)
//    }
//    
//    func test_DataLayer의_DTO인_WeatherInformation이_Model로_정상적으로_변환된다() {
//        let main = Main(temp: 32, maxTemperature: 35, minTemperature: 28)
//        let sys = Sys(sunrise: 14, sunset: 2)
//        let weather = Weather(description: "", id: 1)
//        let weatherInformation = WeatherInformation(name: "이매동", main: main, weather: [weather], sys: sys)
//        
//        let weatherFromEntity = weatherInformation.toDomain()
//        
//        XCTAssertEqual(weatherInformation.sys.sunset, weatherFromEntity.sunset)
//        XCTAssertEqual(weatherInformation.sys.sunrise, weatherFromEntity.sunrise)
//        XCTAssertEqual(weatherInformation.main.maxTemperature, weatherFromEntity.maxTemperature)
//        XCTAssertEqual(weatherInformation.main.minTemperature, weatherFromEntity.minTemperature)
//    }
//}
