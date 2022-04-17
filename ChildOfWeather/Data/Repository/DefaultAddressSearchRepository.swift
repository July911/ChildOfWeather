import Foundation
import CoreLocation

final class DefaultAddressSearchRepository: AddressSearchReopsitory {
    
    let service: CLGeocoder
    
    init() {
        self.service = CLGeocoder()
    }
}
