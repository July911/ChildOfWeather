import Foundation
import RxSwift

final class CurrentLocationViewModel {
    
    private let detailShowUseCase: DetailShowUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    
    init(detailShowUseCase: DetailShowUseCase, imageCacheUseCase: ImageCacheUseCase) {
        self.detailShowUseCase = detailShowUseCase
        self.imageCacheUseCase = imageCacheUseCase
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cachedImage: Observable<ImageCacheData>?
        let locationChange: Observable<Bool>
        let dismiss: Observable<Void>
    }
    
    struct Output {
        let currentImage: Observable<ImageCacheData>
        let weatherDescription: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        
        
        return Output(currentImage: <#T##Observable<ImageCacheData>#>, weatherDescription: <#T##Observable<String>#>)
    }
}
