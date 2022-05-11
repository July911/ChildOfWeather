import Foundation
import RxSwift

final class LikeCityViewModel {
    
    let citySearchUseCase: CitySearchUseCase
    let imageCacheUseCase: ImageCacheUseCase
    let weatherFetchUseCase: DetailWeatherFetchUseCase
    
    init(citySearchUseCase: CitySearchUseCase,
         imageCacheUseCase: ImageCacheUseCase,
         weatherUseCase: DetailWeatherFetchUseCase
    ) {
        self.citySearchUseCase = citySearchUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.weatherFetchUseCase = weatherUseCase
    }
    
    struct Input {
        let viewWillApeear: Observable<Void>
        let didTappedCell: Observable<IndexPath>
    }
    
    struct Ouput {
        let likedCities: Observable<[CityCellViewModel]>
    }
    
    func transform(input: Input) -> Ouput {
        
        let imageCachedData = input.viewWillApeear.compactMap {
            self.imageCacheUseCase.fetchAllCachedCities()
        }.flatMap { $0 }
            .startWith([])
            .distinctUntilChanged()
            
            
        let todayWeather = imageCachedData.flatMap { cities -> Observable<[TodayWeather]> in
            let todayWeathers = cities.map { self.weatherFetchUseCase.fetchTodayWeather(cityName: $0.key as String).asObservable() }
            return Observable.zip(todayWeathers)
        }
        
        let likeCities = Observable.zip(imageCachedData, todayWeather).map { (imageCache, todayWeather) -> [CityCellViewModel] in
            let cityCellViewModels = zip(imageCache, todayWeather).map {
                CityCellViewModel(
                    cityName: $0.0.key as String,
                    image: $0.0,
                    highTemperature: $0.1.maxTemperature,
                    lowTemperature: $0.1.minTemperature
                )
            }
            
            return cityCellViewModels
        }
            
        return Ouput(likedCities: likeCities)
    }
}
