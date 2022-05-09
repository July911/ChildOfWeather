import Foundation
import RxSwift

final class LikeCityViewModel {
    
    let citySearchUseCase: CitySearchUseCase
    let imageCacheUseCase: ImageCacheUseCase
    let weatherUseCase: DetailShowUseCase
    
    init(citySearchUseCase: CitySearchUseCase,
         imageCacheUseCase: ImageCacheUseCase,
         weatherUseCase: DetailShowUseCase
    ) {
        self.citySearchUseCase = citySearchUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.weatherUseCase = weatherUseCase
    }
    
    struct Input {
        let viewWillApeear: Observable<Void>
        let didTappedCell: Observable<IndexPath>
    }
    
    struct Ouput {
        let likedCities: Observable<[CityCellViewModel]>
    }
    
    func transform(input: Input) -> Ouput {
        
        let likeCities = input.viewWillApeear.map { _ -> [ImageCacheData] in
            self.imageCacheUseCase.fetchAllCachedCities()
        }.map { imageCacheData -> [CityCellViewModel] in
            var cities: [CityCellViewModel] = []
            
            imageCacheData.forEach { data in
                let key = data.key
                self.weatherUseCase.fetchTodayWeather(cityName: key as String).asObservable()
                    .do(onNext: { weather in
                        let city = CityCellViewModel(cityName: key as String, image: data, highTemperature: weather.maxTemperature, lowTemperature: weather.minTemperature)
                        cities.append(city)
                    })
            }
            return cities
        }
        
        return Ouput(likedCities: likeCities)
    }
}
