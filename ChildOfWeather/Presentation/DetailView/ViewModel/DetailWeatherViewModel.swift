import Foundation
import RxSwift

final class DetailWeatherViewModel {
    // MARK: - Private Property
    private let city: City
    private let coordinator: SearchViewCoordinator
    private let weatherFetchUseCase: DetailWeatherFetchUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    // MARK: - Initializer
    init(
        detailShowUseCase: DetailWeatherFetchUseCase,
        imageCacheUseCase: ImageCacheUseCase,
        coodinator: SearchViewCoordinator,
        city: City
    ) {
        self.weatherFetchUseCase = detailShowUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.coordinator = coodinator
        self.city = city
    }
    // MARK: - Nested Type
    struct Input {
        let viewWillAppear: Observable<Void>
        let capturedImage: Observable<ImageCacheData>
        let touchUpbackButton: Observable<Void>
    }
    
    struct Output {
        let selectedURLForMap: Observable<URLRequest?>
        let cachedImage: Observable<ImageCacheData>?
        let weatehrDescription: Observable<String>
        let capturedSuccess: Observable<Void>
        let dismiss: Observable<Void>
    }
    // MARK: - Public Method
    func transform(input: Input) -> Output {
        let urlRequest = LocationManager.shared.searchLocation(
            latitude: self.city.coord.lat, longitude: self.city.coord.lon
        )
            .map { LocationManager.shared.fetchURLFromLocation(locationAddress: $0) }
            .map { (urlString) -> URLRequest? in
                guard let quaryAllowed = urlString.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                )
                else {
                    return nil
                }
                guard let url = URL(string: quaryAllowed)
                else {
                    return nil
                }
                return URLRequest(url: url)
            }
       
        let cache = input.viewWillAppear.withUnretained(self)
            .compactMap { (self, _) in
                self.imageCacheUseCase.fetchImage(cityName: self.city.name)
            }
        let weatherDescription = self.extractWeatherDescription(city: city)
        
        let capturedSuccess = input.capturedImage
            .withUnretained(self)
            .filter { (self, _) in
                self.imageCacheUseCase.hasCacheExist(cityName: self.extractCity().name) == false }
            .do(onNext: { (self, image) in
                self.imageCacheUseCase.setCache(object: image)
            })
            .map { _ in }
        
        let dismiss = input.touchUpbackButton
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .do(onNext: { (self, _) in
                self.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
            })
            .map { _ in }
        
        return Output(
            selectedURLForMap: urlRequest,
            cachedImage: cache,
            weatehrDescription: weatherDescription,
            capturedSuccess: capturedSuccess,
            dismiss: dismiss
        )
    }
    
    func extractCity() -> City {
        return self.city
    }
    // MARK: - Private Method 
    private func cache(object: ImageCacheData) {
        self.imageCacheUseCase.setCache(object: object)
    }
    
    private func extractCache(key: String) -> ImageCacheData? {
        self.imageCacheUseCase.fetchImage(cityName: key)
    }
    
    private func extractWeatherDescription(city: City) -> Observable<String> {
        return self.weatherFetchUseCase.fetchTodayWeather(cityName: city.name)
            .asObservable()
            .map { (weather) -> String in
            let sunrise = weather.sunrise.toKoreanTime
            let sunset = weather.sunset.toKoreanTime
            let maxTemp = weather.maxTemperature.toCelsius
            let minTemp = weather.minTemperature.toCelsius
            let description = weather.description
            let weatherDescription = "????????? ??????\(sunrise)\n\n????????? ??????\(sunset)\n\n?????? ?????????  ??????\(maxTemp)???\n\n?????? ????????? ??????\(minTemp)????????????.\n\n ??????????????? ????????? ????????? \(description)?????????."
            return weatherDescription
        }
    }
}

