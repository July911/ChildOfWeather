import UIKit

final class AppCoordinator: Coordinator {
    
    private var childCoordinator: [Coordinator]
    private let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        self.childCoordinator = .init()
        window?.makeKeyAndVisible()
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
        
        let searchViewCoordinator = SearchViewCoordinator(navigationController: .init())
        searchViewCoordinator.parentCoordinator = self
        self.childCoordinator.append(searchViewCoordinator)
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = firstItem
        
        let currentLocationCoordinator = CurrentLocationCoordinator(navigationController: .init())
        currentLocationCoordinator.parentCoordinator = self
        self.childCoordinator.append(currentLocationCoordinator)
        let currentLocationViewController = CurrentLocationViewController()
        currentLocationViewController.tabBarItem = secondItem
        
        let likeCityCoordinator = LikeCityCoordinator(navigationController: .init())
        likeCityCoordinator.parentCoordinator = self
        self.childCoordinator.append(likeCityCoordinator)
        let likeCityViewController = LikeCityViewController()
        likeCityViewController.tabBarItem = thirdItem
        
        tabBarController.viewControllers = [
            searchViewController,
            currentLocationViewController,
            likeCityViewController
        ]
        
        return tabBarController
    }
}
