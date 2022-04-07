import Foundation
import CoreLocation


final class LocationSearchUseCase {
    
    func search(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en-US")
        
        geocoder.reverseGeocodeLocation(
                findLocation, preferredLocale: locale) { (place, error) in

                    let city = place?.last?.name
                    completion(city)
            }
    }
}
