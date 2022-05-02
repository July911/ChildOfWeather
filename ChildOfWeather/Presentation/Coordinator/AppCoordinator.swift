import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator]
    let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
    }
    
    func start() {
        let tabBarController = setTapBarController()
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
        
        
        
        tabBarController.viewControllers = [firstItem, secondItem]
    }
}
