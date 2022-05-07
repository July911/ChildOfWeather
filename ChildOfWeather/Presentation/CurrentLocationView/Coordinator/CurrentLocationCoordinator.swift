import UIKit

final class CurrentLocationCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    private let viewController: CurrentLocationViewController
    private let navigationController: UINavigationController
    private let imageCacheUseCase: ImageCacheUseCase
    
    init(navigationController: UINavigationController,
         viewController: CurrentLocationViewController,
         imageCacheUseCase: ImageCacheUseCase
    ) {
        self.navigationController = navigationController
        self.viewController = viewController
        self.imageCacheUseCase = imageCacheUseCase
    }
    
    func start() {
        CurrentLocationViewModel(
            detailShowUseCase: <#T##DetailShowUseCase#>,
            imageCacheUseCase: <#T##ImageCacheUseCase#>,
            coordinator: self
        )
    }
}
