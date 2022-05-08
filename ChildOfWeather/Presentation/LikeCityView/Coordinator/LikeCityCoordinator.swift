import UIKit

final class LikeCityCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    weak var viewController: LikeCityViewController?
    private let imageCacheUseCase: ImageCacheUseCase
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, viewController: LikeCityViewController, imageCacheUseCase: ImageCacheUseCase) {
        self.navigationController = navigationController
        self.viewController = viewController
        self.imageCacheUseCase = imageCacheUseCase
    }
    
    func start() {
        
        guard let viewController = self.viewController
        else {
            return
        }
        
        viewController.viewModel = LikeCityViewModel(
            citySearchUseCase: CitySearchUseCase(searchRepository: DefaultCitySearchRepository()),
            imageCacheUseCase: self.imageCacheUseCase
        )
        
        self.navigationController.setViewControllers([viewController], animated: false)
    }
}
