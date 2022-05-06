import Foundation
import RxSwift

final class LikeCityViewModel {
    
    let citySearchUseCase: CitySearchUseCase
    let imageCacheUseCase: ImageCacheUseCase
    
    init(citySearchUseCase: CitySearchUseCase, imageCacheUseCase: ImageCacheUseCase) {
        self.citySearchUseCase = citySearchUseCase
        self.imageCacheUseCase = imageCacheUseCase
    }
    
    struct Input {
        let viewWillApeear: Observable<Void>
        let didTappedCell: Observable<IndexPath>
    }
    
    struct Ouput {
        let likedCities: Observable<[CityCellViewModel]>
    }
    
    func transform(input: Input) -> Ouput {
        
    }
}
