import Foundation
import RxSwift

final class DetailShowViewModel {
    // MARK: - Private Property
    private let city: City
    private let coordinator: MainCoordinator
    private let detailShowUseCase: DetailShowUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    private let bag = DisposeBag()
    // MARK: - Initializer
    init(
        detailShowUseCase: DetailShowUseCase,
        imageCacheUseCase: ImageCacheUseCase,
        coodinator: MainCoordinator,
        city: City
    ) {
        self.detailShowUseCase = detailShowUseCase
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
        let selectedURLForMap: Observable<String>
        let cachedImage: Observable<ImageCacheData>?
        let weatehrDescription: Observable<String>
    }
    // MARK: - Open Method
    func transform(input: Input, disposeBag: DisposeBag) -> Output? {
        guard let output = self.configureOutput()
        else {
            return nil
        }
        
        input.capturedImage
            .withUnretained(self)
            .filter { _ in self.imageCacheUseCase.hasCacheExist(cityName: self.extractCity().name) == false }
            .subscribe(onNext: { (self, image) in
                self.imageCacheUseCase.setCache(object: image)
            }).disposed(by: disposeBag)
        
        input.touchUpbackButton
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe( onNext: { _ in
                self.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
            }).disposed(by: disposeBag)
        
        return output
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
        return self.detailShowUseCase.extractTodayWeather(cityName: city.name)
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
        guard self.imageCacheUseCase.hasCacheExist(cityName: city.name)
        else {
            return nil
        }
        guard let image = self.imageCacheUseCase.fetchImage(cityName: city.name)
        else {
            return nil
        }
        
        return Observable.just(image)
    }
    
    private func configureOutput() -> Output? {
         let url = LocationManager.shared.searchLocation(latitude: self.city.coord.lat, longitude: self.city.coord.lon)
            .map { self.detailShowUseCase.fetchURL(from: $0) }
        
        let cache = self.loadCacheImage(city: self.city)
        let weatherDescription = self.extractWeatherDescription(city: city)
        return Output(selectedURLForMap: url, cachedImage: cache, weatehrDescription: weatherDescription)
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
