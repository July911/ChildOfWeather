import UIKit

final class LikeCityCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    weak var viewController: LikeCityViewController?
    private let imageCacheUseCase: ImageCacheUseCase?
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, viewController: LikeCityViewController, imageCacheUseCase: ImageCacheUseCase) {
        self.navigationController = navigationController
        self.viewController = viewController
        self.imageCacheUseCase = imageCacheUseCase
    }
    
    func start() {
        guard let viewController = self.viewController, let imageCacheUseCase = self.imageCacheUseCase
        else {
            return
        }
        
        viewController.viewModel = LikeCityViewModel(
            citySearchUseCase: CitySearchUseCase(searchRepository: DefaultCitySearchRepository()),
            imageCacheUseCase: imageCacheUseCase
        )
        
        self.navigationController.setViewControllers([viewController], animated: false)
    }
}
