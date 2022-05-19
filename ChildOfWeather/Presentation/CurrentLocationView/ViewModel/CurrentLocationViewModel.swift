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
        let cachedImage: Observable<ImageCacheData>
        let locationChange: Observable<Void>
        let dismiss: Observable<Void>
    }
    
    struct Output {
        let currentImage: Observable<ImageCacheData>
        let isImageCached: Observable<Bool>
        let currentAddressDescription: Observable<String>
        let weatherDescription: Observable<String>
        let currentAddressWebViewURL: Observable<URLRequest?>
    }
    // MARK: - Method 
    func transform(input: Input) -> Output {
        
        let isImageCache = input.locationChange.withLatestFrom(input.cachedImage)
            .do { imageCacheData in
                let newImageCacheData = ImageCacheData(key: "current" as NSString, value: imageCacheData.value)
                self.imageCacheUseCase.setCache(object: newImageCacheData)
            }.flatMap { _ -> Observable<Bool> in
                let isCahced = self.imageCacheUseCase.hasCacheExist(cityName: "current")
                return Observable.of(isCahced)
            }
        
        let imageCacheData = input.viewWillAppear.compactMap {
            self.imageCacheUseCase.fetchImage(cityName: "current")
        }
        
        let locationCoodinate = input.viewWillAppear.map {
            LocationManager.shared.extractCurrentLocation()
        }.share(replay: 1)
        
        let currentAddress = locationCoodinate.flatMap { (coordinate) -> Observable<String> in
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            return LocationManager.shared.searchLocation(latitude: latitude, longitude: longitude)
        }.share(replay: 1)
        
        let weatherDescription = locationCoodinate.flatMap { (coodinate) -> Observable<TodayWeather> in
            return self.weatherFetchUseCase.fetchTodayWeather(
                latitude: coodinate.latitude,
                longitude: coodinate.longitude
            ).asObservable()
        }.map { todayWeather -> String in
            let sunSet = todayWeather.sunset.toKoreanTime.description
            let sunRise = todayWeather.sunrise.toKoreanTime.description
            let minTemperature = todayWeather.minTemperature.toCelsius.description
            let maxTemperature = todayWeather.maxTemperature.toCelsius.description
            return "오늘의 일출은 \(sunRise)시,\n\n 일몰은 \(sunSet) \n\n 최고기온은 \(maxTemperature) 최저기온은 \(minTemperature)입니다. 전체적인 날씨는 \(todayWeather.description)입니다."
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
        
        return Output(
            currentImage: imageCacheData,
            isImageCached: isImageCache,
            currentAddressDescription: currentAddress,
            weatherDescription: weatherDescription,
            currentAddressWebViewURL: currentAddressWebViewURL
        )
    }
}
