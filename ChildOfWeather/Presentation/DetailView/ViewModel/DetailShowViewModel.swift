import Foundation
import RxSwift

final class DetailShowViewModel {
    
    private let city: BehaviorSubject<City>
    private let coordinator: MainCoordinator
    private let detailShowUseCase: DetailShowUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    private let bag = DisposeBag()
    
    init(
        detailShowUseCase: DetailShowUseCase,
        imageCacheUseCase: ImageCacheUseCase,
        coodinator: MainCoordinator,
        city: BehaviorSubject<City>
    ) {
        self.detailShowUseCase = detailShowUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.coordinator = coodinator
        self.city = city
    }
    
    struct Input {
        let viewWillAppear: Observable<Void> //TODO: getCache
        let didCaptureView: Observable<Void>
        let capturedImage: Observable<ImageCacheData>
        let touchUpbackButton: Observable<Void>
    }
    
    struct Output {
        let selectedURLForMap: Observable<String>
        let cachedImage: Observable<ImageCacheData>?
        let weatehrDescription: Observable<String>
    }
    
    func cache(object: ImageCacheData) {
        self.imageCacheUseCase.setCache(object: object)
    }
    
    func extractCache(key: String) -> ImageCacheData? {
        self.imageCacheUseCase.fetchImage(cityName: key)
    }
    
    private func extractWeatherDescription(city: City) -> Observable<String> {
        return self.detailShowUseCase.extractTodayWeather(cityName: city.name).flatMap { (weather) -> Observable<String> in
            let sunrise = weather.sunrise.toKoreanTime
            let sunset = weather.sunset.toKoreanTime
            let maxTemp = weather.maxTemperature.toCelsius
            let minTemp = weather.minTemperature.toCelsius
            let weatherDescription = "일출은 오전\(sunrise)\n일몰은 오후\(sunset)\n최고 기온은  섭씨\(maxTemp)도\n최저 기온은 섭씨\(minTemp)도입니다."
            return Observable.just(weatherDescription)
        }
    }
    
    private func loadCacheImage(city: City) -> Observable<ImageCacheData>? {
        guard self.imageCacheUseCase.checkCacheExist(cityName: city.name)
        else {
            return nil
        }
        guard let image = self.imageCacheUseCase.fetchImage(cityName: city.name)
        else {
            return nil
        }
        
        return Observable.just(image)
    }

    func transform(input: Input) -> Output? {
        guard let output = self.configureOutput()
        else {
            return nil 
        }
        
        let combin = Observable.combineLatest(input.didCaptureView, input.capturedImage) { (event, image) -> ImageCacheData in
            return image
        }
        
             combin
            .withUnretained(self)
            .subscribe(onNext: { (self, image) in
                self.imageCacheUseCase.setCache(object: image)
            }).disposed(by: self.bag)
        
        input.touchUpbackButton
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe( onNext: { _ in
                self.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
            }).disposed(by: self.bag)
        
        return output
    }
    
    private func configureOutput() -> Output? {
        let url = self.city
            .flatMap { LocationManager.shared.searchLocation(latitude: $0.coord.lat, longitude: $0.coord.lon) }
            .map { self.detailShowUseCase.fetchURL(from: $0) }
        
        guard let city = try? self.city.value()
        else {
            return nil
        }
        let cache = self.loadCacheImage(city: city)
        let weatherDescription = self.extractWeatherDescription(city: city)
        return Output(selectedURLForMap: url, cachedImage: cache, weatehrDescription: weatherDescription)
    }
    
    func extractCity() -> City? {
        guard let city = try? self.city.value()
        else {
            return nil 
        }
        
        return city
    }
}

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
