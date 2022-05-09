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
        let detailShowUseCase = DetailWeatherFetchUseCase(
            weatherRepository: DefaultWeatherRepository(service: APIService())
        )
        let currentLocationViewModel = CurrentLocationViewModel(
            detailShowUseCase: detailShowUseCase,
            imageCacheUseCase: self.imageCacheUseCase,
            coordinator: self
        )
        self.viewController.viewModel = currentLocationViewModel
        
        self.navigationController.setViewControllers([self.viewController], animated: false)
    }
}
