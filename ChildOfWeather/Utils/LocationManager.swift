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
    
    func extractCurrentLocation() -> (latitude: Double, longitude: Double) {
//        let latitude = Double(locationManager.location?.coordinate.latitude ?? .zero)
//        let longitude = Double(locationManager.location?.coordinate.longitude ?? .zero)
        //TODO: 현재위치를 받아오는 코드 추가
        let mockLatitude = 37.44463800000
        let mockLongitude = 127.17296800000
        return (mockLatitude, mockLongitude)
    }
    
    func fetchURLFromLocation(locationAddress address: String) -> String {
        let googleBaseURL = "https://www.google.com/maps?q="
        let fullURL = googleBaseURL + address
        
        return fullURL
    }
}
