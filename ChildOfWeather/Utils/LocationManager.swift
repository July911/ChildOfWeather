import Foundation
import CoreLocation

final class LocationManager {
    
    static let shared = LocationManager()
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    private init() {
        
    }
    
    func searchLocation(
        latitude: Double,
        longitude: Double,
        completion: @escaping (String?) -> Void
    ) {
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let locale = Locale(identifier: "en-US")
        
        self.geocoder.reverseGeocodeLocation(
            findLocation,
            preferredLocale: locale) { (place, error) in
                let cityAddress = place?.last?.name
                completion(cityAddress)
            }
    }
}
