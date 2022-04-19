import XCTest
@testable import ChildOfWeather

class DetailShowUseCaseTests: XCTestCase {
    
    var sut: DetailShowUseCase?

    override func setUpWithError() throws {
        let repository = DefaultWeatherRepository(service: MockAPIService())
        sut = DetailShowUseCase(weatherRepository: repository)
    }

    override func tearDownWithError() throws {
        sut = nil 
    }
    
    func test_주소를_정상적으로_입력했을때_제대로된_URL이_나온다() {
        let URL = sut?.fetchURL(from: "153-2 Imae-dong")
        
        XCTAssertEqual(URL, "https://www.google.com/maps?q=153-2 Imae-dong")
    }
}
