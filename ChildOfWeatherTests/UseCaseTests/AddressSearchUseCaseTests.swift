import XCTest
@testable import ChildOfWeather

class AddressSearchUseCaseTests: XCTestCase {
    
    var sut: AddressSearchUseCase?

    override func setUpWithError() throws {
        let addressSearchRepository = DefaultAddressSearchRepository()
        let addressSearchUseCase = AddressSearchUseCase(addressRepository: addressSearchRepository)
        sut = addressSearchUseCase
    }

    override func tearDownWithError() throws {
        sut = nil 
    }
    
    func test_AddressSearchUseCase_이매동_위경도를_입력했을때_이매동_주소가_나온다() {
        let imaelatitude = 37.39508700000
        let imaelongitude = 127.12415500000
     
        let promise = expectation(description: "")
        self.sut?.searchLocation(latitude: imaelatitude, longitude: imaelongitude) { (address) in
            XCTAssertEqual(address!, "153-2 Imae-dong")
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 3)
    }
}
