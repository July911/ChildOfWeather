import Foundation

final class DetailShowViewModel {
    
    let city: City
    private let coordinator: MainCoordinator
    private let detailShowUseCase: DetailShowUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    weak var delegate: DetailViewModelDelegate?
    
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
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func extractURLForMap() {
        LocationManager.shared.searchLocation(
            latitude: city.coord.lat,
            longitude: city.coord.lon,
            completion: { [weak self] strings in
            guard let adress = strings
                else {
                return
            }
                
            let urlString = self?.detailShowUseCase.fetchURL(from: adress)
                
            guard let replace = urlString?.replacingOccurrences(of: " ", with: "%20")
                else {
                return
            }
            guard let url = URL(string: replace)
                else {
                return
            }
            
            DispatchQueue.main.async {
                self?.delegate?.loadWebView(url: url)
            }
        })
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
            self.delegate?.loadImageView()
        } 
    }
    
    func occuredBackButtonTapEvent() {
        self.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
    }
    
    func transform(input: Input) -> Output {
        <#code#>
    }
}

protocol DetailViewModelDelegate: AnyObject {
    func loadWebView(url: URL)
    func loadTodayDescription(weather description: String)
    func loadImageView()
    func cacheImage()
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
