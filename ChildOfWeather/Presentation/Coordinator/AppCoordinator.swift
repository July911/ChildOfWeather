import UIKit

final class AppCoordinator: Coordinator {
    
    private var childCoordinator: [Coordinator]
    private let window: UIWindow?
    private let navigationController: UINavigationController
    
    init(_ window: UIWindow?, navigationController: UINavigationController) {
        self.navigationController = navigationController
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
        
        tabBarController.viewControllers = [searchViewController, currentLocationViewController]
        
        return tabBarController
    }
}
