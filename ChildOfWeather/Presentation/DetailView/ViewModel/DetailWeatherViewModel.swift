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
    // MARK: - Open Method
    func transform(input: Input) -> Output {
        let urlRequest = LocationManager.shared.searchLocation(latitude: self.city.coord.lat, longitude: self.city.coord.lon)
            .map { LocationManager.shared.fetchURLFromLocation(locationAddress: $0) }
            .map { (urlString) -> URLRequest? in
                guard let quaryAllowed = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                else {
                    return nil
                }
                guard let url = URL(string: quaryAllowed)
                else {
                    return nil
                }
                return URLRequest(url: url)
            }
       
        let cache = self.loadCacheImage(city: self.city)?.sample(input.viewWillAppear)
        let weatherDescription = self.extractWeatherDescription(city: city)
        
        let capturedSuccess = input.capturedImage
            .withUnretained(self)
            .filter { _ in
                self.imageCacheUseCase.hasCacheExist(cityName: self.extractCity().name) == false }
            .do(onNext: { (self, image) in
                self.imageCacheUseCase.setCache(object: image)
            }).map { _ in }
        
        let dismiss = input.touchUpbackButton
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in
                self.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
            }).map { _ in }
        
        return Output(selectedURLForMap: urlRequest, cachedImage: cache, weatehrDescription: weatherDescription, capturedSuccess: capturedSuccess, dismiss: dismiss)
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
            let weatherDescription = "일출은 오전\(sunrise)\n일몰은 오후\(sunset)\n최고 기온은  섭씨\(maxTemp)도\n최저 기온은 섭씨\(minTemp)도입니다."
            return weatherDescription
        }
    }
        
    private func loadCacheImage(city: City) -> Observable<ImageCacheData>? {
        
        guard let image = self.imageCacheUseCase.fetchImage(cityName: city.name)
        else {
            return nil
        }
        
        return Observable.just(image)
    }
}
// MARK: - Extension
fileprivate extension Double {
    
    var toCelsius: Double {
        let celsius = (self - 273.15)
        let droppedCelsius = String(celsius).prefix(5)
        return Double(droppedCelsius) ?? .zero
    }
}

fileprivate extension Int {
    
    var toKoreanTime: String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DefaultDateformatter.shared.dateformatter
        formatter.dateFormat = "HH: mm"
        return formatter.string(from: time)
    }
}
