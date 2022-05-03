import Foundation
import RxSwift

final class CurrentLocationViewModel {
    
    private let detailShowUseCase: DetailShowUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    private let coordinator: Coordinator
    
    init(
        detailShowUseCase: DetailShowUseCase,
        imageCacheUseCase: ImageCacheUseCase,
        coordinator: Coordinator
    ) {
        self.detailShowUseCase = detailShowUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.coordinator = coordinator
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
