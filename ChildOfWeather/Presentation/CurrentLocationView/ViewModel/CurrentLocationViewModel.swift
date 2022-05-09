import Foundation
import RxSwift

final class CurrentLocationViewModel {
    // MARK: - Properties
    private let weatherFetchUseCase: DetailWeatherFetchUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    private let coordinator: Coordinator
    // MARK: - Initailizer
    init(
        detailShowUseCase: DetailWeatherFetchUseCase,
        imageCacheUseCase: ImageCacheUseCase,
        coordinator: Coordinator
    ) {
        self.weatherFetchUseCase = detailShowUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.coordinator = coordinator
    }
    // MARK: - Nested Type
    struct Input {
        let viewWillAppear: Observable<Void>
        let cachedImage: Observable<ImageCacheData>?
        let locationChange: Observable<Void>
        let dismiss: Observable<Void>
    }
    
    struct Output {
        let currentImage: Observable<ImageCacheData>
        let currentAddressDescription: Observable<String>
        let weatherDescription: Observable<String>
        let currentAddressWebViewURL: Observable<URLRequest?>
    }
    // MARK: - Method 
    func transform(input: Input) -> Output {
        
        let locationCoodinate = input.viewWillAppear.map {
            LocationManager.shared.extractCurrentLocation()
        }.share(replay: 1)
        
        let currentAddress = locationCoodinate.flatMap { (coordinate) -> Observable<String> in
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            return LocationManager.shared.searchLocation(latitude: latitude, longitude: longitude)
        }
        
        let weatherDescription = locationCoodinate.flatMap { (coodinate) -> Observable<TodayWeather> in
            return self.weatherFetchUseCase.fetchTodayWeather(
                latitude: coodinate.latitude,
                longitude: coodinate.longitude
            ).asObservable()
        }.map { todayWeather -> String in
            
        }
        
        let currentAddressWebViewURL = currentAddress.map { (address) -> URLRequest? in
            let urlString = LocationManager.shared.fetchURLFromLocation(locationAddress: address)
            
            guard let encodedAddress = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else {
                return nil
            }
            
            guard let url = URL(string: encodedAddress)
            else {
                return nil
            }
            
            return URLRequest(url: url)
        }
        
        return Output(currentImage: <#T##Observable<ImageCacheData>#>, currentAddressDescription: currentAddress, weatherDescription: <#T##Observable<String>#>, currentAddressWebViewURL: currentAddressWebViewURL)
    }
}
