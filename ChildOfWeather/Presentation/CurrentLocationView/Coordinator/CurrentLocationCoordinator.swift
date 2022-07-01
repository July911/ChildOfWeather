import UIKit

final class CurrentLocationCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    private let imageCacheUseCase: ImageCacheUseCase
    
    init(
         imageCacheUseCase: ImageCacheUseCase
    ) {
        self.imageCacheUseCase = imageCacheUseCase
    }
    
    @discardableResult
    func start() -> UINavigationController {
        
        let viewController = CurrentLocationViewController()
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        
        let detailShowUseCase = DetailWeatherFetchUseCase(
            weatherRepository: DefaultWeatherRepository(service: URLSessionService())
        )
        let currentLocationViewModel = CurrentLocationViewModel(
            detailShowUseCase: detailShowUseCase,
            imageCacheUseCase: self.imageCacheUseCase,
            coordinator: self
        )
        viewController.viewModel = currentLocationViewModel
        
        navigationController.setViewControllers([viewController], animated: false)
        
        return navigationController
    }
}
