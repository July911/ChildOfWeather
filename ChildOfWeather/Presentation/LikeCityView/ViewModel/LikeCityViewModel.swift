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
        
    }
    
    struct Ouput {
        
    }
    
    func transform(input: Input) -> Ouput {
        
    }
}
