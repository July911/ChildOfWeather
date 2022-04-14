import Foundation
import CoreLocation

final class LocationSearchUseCase {
    
    let addressRepository: AddressSearchReopsitory
    
    init(addressRepository: AddressSearchReopsitory) {
        self.addressRepository = addressRepository
    }
    
    func searchLocation(
        latitude: Double,
        longitude: Double,
        completion: @escaping (String?) -> Void
    ) {
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let locale = Locale(identifier: "en-US")
        
        self.addressRepository.service.reverseGeocodeLocation(
                findLocation,
                preferredLocale: locale) { (place, error) in
                    let city = place?.last?.name
                    completion(city)
            }
    }
}
