import UIKit

final class AppCoordinator: Coordinator {
   
    private var childCoordinator: [Coordinator]
    private let window: UIWindow?
    private let imageCacheUseCase: ImageCacheUseCase
    
    init(_ window: UIWindow?) {
        self.window = window
        self.childCoordinator = .init()
        window?.makeKeyAndVisible()
        self.imageCacheUseCase = ImageCacheUseCase(
            imageProvideRepository: DefaultImageProvideRepository()
        )
    }
    
    @discardableResult
    func start() -> UINavigationController {
        let tabBarController = self.setTapBarController()
        self.window?.rootViewController = tabBarController
        
        return UINavigationController()
    }
    
    func setTapBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let firstItem = UITabBarItem(title: "AllCity", image: nil, tag: 0)
        let secondItem = UITabBarItem(title: "Current", image: nil, tag: 1)
        let thirdItem = UITabBarItem(title: "Like", image: nil, tag: 2)
        
        let searchViewCoordinator = SearchViewCoordinator(
            imageCacheUseCase: self.imageCacheUseCase
        )
        let searchNavigationController = searchViewCoordinator.start()
        searchViewCoordinator.parentCoordinator = self
        self.childCoordinator.append(searchViewCoordinator)
        searchNavigationController.tabBarItem = firstItem
        
        let currentLocationCoordinator = CurrentLocationCoordinator(
            imageCacheUseCase: self.imageCacheUseCase
            )
        currentLocationCoordinator.parentCoordinator = self
        self.childCoordinator.append(currentLocationCoordinator)
        let currentLocationNavigationController = currentLocationCoordinator.start()
        currentLocationNavigationController.tabBarItem = secondItem
        
        let likeCityCoordinator = LikeCityCoordinator(
            imageCacheUseCase: self.imageCacheUseCase
        )
        likeCityCoordinator.parentCoordinator = self
        self.childCoordinator.append(likeCityCoordinator)
        let likeCityNavigationController = likeCityCoordinator.start()
        likeCityNavigationController.tabBarItem = thirdItem
        
        tabBarController.setViewControllers([
            searchNavigationController,
            currentLocationNavigationController,
            likeCityNavigationController
        ],animated: true)
        
        tabBarController.tabBar.isTranslucent = false
        
        return tabBarController
    }
    
    private func configureImageCacheUseCase() -> ImageCacheUseCase {
        return ImageCacheUseCase(
            imageProvideRepository: DefaultImageProvideRepository()
        )
    }
}
