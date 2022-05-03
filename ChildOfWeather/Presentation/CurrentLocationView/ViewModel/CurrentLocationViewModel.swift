import Foundation
import RxSwift

final class CurrentLocationViewModel {
    // MARK: - Properties
    private let detailShowUseCase: DetailShowUseCase
    private let imageCacheUseCase: ImageCacheUseCase
    private let coordinator: Coordinator
    // MARK: - Initailizer
    init(
        detailShowUseCase: DetailShowUseCase,
        imageCacheUseCase: ImageCacheUseCase,
        coordinator: Coordinator
    ) {
        self.detailShowUseCase = detailShowUseCase
        self.imageCacheUseCase = imageCacheUseCase
        self.coordinator = coordinator
    }
    // MARK: - Nested Type
    struct Input {
        let viewWillAppear: Observable<Void>
        let cachedImage: Observable<ImageCacheData>?
        let locationChange: Observable<Void>
        let dismiss: Observable<Void>
    }
    
    struct Output {
        let currentImage: Observable<ImageCacheData>
        let weatherDescription: Observable<String>
    }
    // MARK: - Method 
    func transform(input: Input) -> Output {
        
        
        
        return Output(currentImage: <#T##Observable<ImageCacheData>#>, weatherDescription: <#T##Observable<String>#>)
    }
}
