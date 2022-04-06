import Foundation
import CoreLocation


final class LocationSearchUseCase {
    
    func search(latitude: Double, longitude: Double) -> String? {
        var cityLocation: String?
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(
            findLocation,
            preferredLocale: locale,
            completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name {
                    cityLocation = name
                }
            }
        })
        return cityLocation
    }
}
