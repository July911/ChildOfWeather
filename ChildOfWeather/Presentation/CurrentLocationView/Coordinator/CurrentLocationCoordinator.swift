import UIKit

final class CurrentLocationCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
