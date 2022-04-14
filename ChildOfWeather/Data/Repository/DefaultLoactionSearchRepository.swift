import Foundation
import CoreLocation

final class DefaultAddressSearchRepository: AddressSearchReopsitory {
    
    let service: CLGeocoder
    
    init(service: CLGeocoder) {
        self.service = CLGeocoder()
    }
}
