import UIKit

final class AppCoordinator: Coordinator {
    
    private var childCoordinator: [Coordinator]
    private let window: UIWindow?
    private let imageCacheUseCase: ImageCacheUseCase
    
    init(_ window: UIWindow?) {
        self.window = window
        self.childCoordinator = .init()
        window?.makeKeyAndVisible()
        self.imageCacheUseCase = ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository())
    }
    
    func start() {
        let tabBarController = self.setTapBarController()
        self.window?.rootViewController = tabBarController
    }
    
    func setTapBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let firstItem = UITabBarItem(title: "AllCity", image: nil, tag: 0)
        let secondItem = UITabBarItem(title: "Current", image: nil, tag: 1)
        let thirdItem = UITabBarItem(title: "Like", image: nil, tag: 2)
        
        let searchViewController = SearchViewController()
        let searchViewCoordinator = SearchViewCoordinator(
            navigationController: .init(),
            viewController: searchViewController,
            imageCacheUseCase: self.imageCacheUseCase
        )
        searchViewCoordinator.parentCoordinator = self
        self.childCoordinator.append(searchViewCoordinator)
        searchViewController.tabBarItem = firstItem
        
        let currentLocationViewController = CurrentLocationViewController()
        let currentLocationCoordinator = CurrentLocationCoordinator(
            navigationController: .init(),
            viewController: currentLocationViewController,
            imageCacheUseCase: self.imageCacheUseCase
            )
        currentLocationCoordinator.parentCoordinator = self
        self.childCoordinator.append(currentLocationCoordinator)
        currentLocationViewController.tabBarItem = secondItem
        
        let likeCityViewController = LikeCityViewController()
        let likeCityCoordinator = LikeCityCoordinator(
            navigationController: .init(),
            viewController: likeCityViewController,
            imageCacheUseCase: self.imageCacheUseCase
        )
        likeCityCoordinator.parentCoordinator = self
        self.childCoordinator.append(likeCityCoordinator)
        likeCityViewController.tabBarItem = thirdItem
        
        tabBarController.viewControllers = [
            searchViewController,
            currentLocationViewController,
            likeCityViewController
        ]
        
        return tabBarController
    }
    
    private func configureImageCacheUseCase() -> ImageCacheUseCase {
        return ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository())
    }
}
