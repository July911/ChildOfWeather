import Foundation

final class DetailShowViewModel {
    
    let coordinator: MainCoordinator
    let city: City
    private let detailShowUseCase: DetailShowUseCase
    private let locationSearchUseCase: LocationSearchUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    weak var delegate: DetailViewModelDelegate?
    
    init(
        detailShowUseCase: DetailShowUseCase,
         locationSearchUseCase: LocationSearchUseCase,
        imageCacheUseCase: ImageCacheUseCase,
        coodinator: MainCoordinator,
        city: City
    ) {
        self.detailShowUseCase = detailShowUseCase
        self.locationSearchUseCase = locationSearchUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.coordinator = coodinator
        self.city = city
    }
    
    func extractURLForMap() {
        self.locationSearchUseCase.searchLocation(
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
            let sunrise = weather.sunrise.toKoreanTime()
            let sunset = weather.sunset.toKoreanTime()
            let maxTemp = weather.maxTemperature.toCelsius()
            let weatherDescription = "일출은 \(sunrise) 입니다. 일몰은 \(sunset) 기온은 \(maxTemp)입니다."
                
            self?.delegate?.loadTodayDescription(weather: weatherDescription)
        }
    }
    
    func loadCacheImage() {
        if self.imageCacheUseCase.checkCacheExist(cityName: self.city.name) == true {
            self.delegate?.loadImageView()
        } 
    }
}

protocol DetailViewModelDelegate: AnyObject {
    func loadWebView(url: URL)
    func loadTodayDescription(weather description: String)
    func loadImageView()
    func cacheImage()
}

private extension Double {
    
    func toCelsius() -> Double {
        return (self - 32)/1.8
    }
}
