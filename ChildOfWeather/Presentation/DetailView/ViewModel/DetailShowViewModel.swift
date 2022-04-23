import Foundation
import RxSwift

final class DetailShowViewModel {
    
    private let city: Observable<City>
    private let coordinator: MainCoordinator
    private let detailShowUseCase: DetailShowUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    
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
        let didCaptureView: Observable<ImageCacheData>
        let touchUpbackButton: Observable<Void>
    }
    
    struct Output {
        let selectedCity: Observable<City>
        let selectedWeather: Observable<TodayWeather>
        let selectedURLForMap: Observable<String>
        let cachedImage: Observable<ImageCacheData>?
    }
    
    func cache(object: ImageCacheData) {
        self.imageCacheUseCase.setCache(object: object)
    }
    
    func extractCache(key: String) -> ImageCacheData? {
        self.imageCacheUseCase.fetchImage(cityName: key)
    }
    
    func extractWeatherDescription() {
        self.detailShowUseCase.extractTodayWeather(
            cityName: self.city.name) { [weak self] (weather) in
            let sunrise = weather.sunrise.toKoreanTime
            let sunset = weather.sunset.toKoreanTime
            let maxTemp = weather.maxTemperature.toCelsius
            let minTemp = weather.minTemperature.toCelsius
            let weatherDescription = "일출은 오전\(sunrise)\n일몰은 오후\(sunset)\n최고 기온은  섭씨\(maxTemp)도\n최저 기온은 섭씨\(minTemp)도입니다."
                
            self?.delegate?.loadTodayDescription(weather: weatherDescription)
        }
    }
    
    func loadCacheImage() {
        if self.imageCacheUseCase.checkCacheExist(cityName: self.city.name) == true {
          
        } 
    }
    
    func occuredBackButtonTapEvent() {
        self.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
    }
    
    func transform(input: Input) -> Output {
        <#code#>
    }
    
    private func configureOutput() -> Output {
        let location = LocationManager.shared.searchLocation(latitude: city.coord.lat, longitude: city.coord.lon)
        
        return Output(selectedCity: self.city, selectedWeather: <#T##Observable<TodayWeather>#>, selectedURLForMap: location, cachedImage: <#T##Observable<ImageCacheData>?#>)
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
