import Foundation
import RxSwift

final class DetailShowViewModel {
    
    private let city: Observable<City>
    private let coordinator: MainCoordinator
    private let detailShowUseCase: DetailShowUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    private let bag = DisposeBag()
    
    init(
        detailShowUseCase: DetailShowUseCase,
        imageCacheUseCase: ImageCacheUseCase,
        coodinator: MainCoordinator,
        city: Observable<City>
    ) {
        self.detailShowUseCase = detailShowUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.coordinator = coodinator
        self.city = city
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
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
        return self.detailShowUseCase.extractTodayWeather(cityName: city.name).map { (weather) -> String in
            let sunrise = weather.sunrise.toKoreanTime
            let sunset = weather.sunset.toKoreanTime
            let maxTemp = weather.maxTemperature.toCelsius
            let minTemp = weather.minTemperature.toCelsius
            let weatherDescription = "일출은 오전\(sunrise)\n일몰은 오후\(sunset)\n최고 기온은  섭씨\(maxTemp)도\n최저 기온은 섭씨\(minTemp)도입니다."
            return weatherDescription
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

    func transform(input: Input) -> Output {
        let output = self.configureOutput()
        
        input.capturedImage.sample(input.didCaptureView)
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
    
    private func configureOutput() -> Output {
        var selectedURLForMap: Observable<String>
        var cachedImage: Observable<ImageCacheData>?
        var weatehrDescription: Observable<String>
        
        self.city
            .withUnretained(self)
            .subscribe(onNext: {(self, city) in
            selectedURLForMap = LocationManager.shared.searchLocation(
                latitude: city.coord.lat,
                longitude: city.coord.lon
            )
            weatehrDescription = self.extractWeatherDescription(city: city)
            cachedImage = self.loadCacheImage(city: city)
        }).disposed(by: self.bag)
        
        return Output(
            selectedURLForMap: selectedURLForMap,
            cachedImage: cachedImage,
            weatehrDescription: weatehrDescription
        )
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
