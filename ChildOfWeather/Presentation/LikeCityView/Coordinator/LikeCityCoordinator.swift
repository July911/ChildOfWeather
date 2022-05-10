import UIKit

final class LikeCityCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    private let imageCacheUseCase: ImageCacheUseCase
    
    init(imageCacheUseCase: ImageCacheUseCase) {
        self.imageCacheUseCase = imageCacheUseCase
    }
    
    func start() -> UINavigationController {
        
        let viewController = LikeCityViewController()
        let navigaionController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = LikeCityViewModel(
            citySearchUseCase: CitySearchUseCase(searchRepository: DefaultCitySearchRepository()),
            imageCacheUseCase: self.imageCacheUseCase,
            weatherUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: APIService()))
        )
        
        navigaionController.setViewControllers([viewController], animated: false)
        
        return navigaionController
    }
}
