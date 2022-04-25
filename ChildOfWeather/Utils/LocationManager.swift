import Foundation
import CoreLocation
import RxSwift

final class LocationManager {
    
    static let shared = LocationManager()
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    private init() {
        
    }
    
    func searchLocation(
        latitude: Double,
        longitude: Double
    ) -> Observable<String> {
        
        return Observable<String>.create { emitter in
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let locale = Locale(identifier: "ko-KR")
        
        self.geocoder.reverseGeocodeLocation(
            findLocation,
            preferredLocale: locale) { (place, error) in
                guard let city = place?.last?.name
                else {
                    emitter.onError(APICallError.errorExist)
                    return
                } 
                emitter.onNext(city)
            }
            
            return Disposables.create ()
        }
    }
}
