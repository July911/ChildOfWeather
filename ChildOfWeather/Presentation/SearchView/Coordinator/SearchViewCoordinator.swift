import UIKit
import CoreLocation
import RxSwift

final class SearchViewCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    weak var viewController: SearchViewController?
    private let imageCacheUseCase: ImageCacheUseCase
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, viewController: SearchViewController, imageCacheUseCase: ImageCacheUseCase) {
        self.navigationController = navigationController
        self.viewController = viewController
        self.imageCacheUseCase = imageCacheUseCase
    }

    func start() {
        let viewController = SearchViewController()
        let citySearchRepository = DefaultCitySearchRepository()
        let searchUseCase = CitySearchUseCase(
            searchRepository: citySearchRepository
        )
        let searchViewModel = SearchViewModel(
            searchUseCase: searchUseCase,
            coodinator: self
        )
        viewController.viewModel = searchViewModel
        self.navigationController.setViewControllers([viewController], animated: false)
    }

    func occuredViewEvent(with event: Event.View) {

        switch event {
        case .presentDetailShowUIViewController(let cityName):
            let detailShowViewController = self.configureDetailShowViewController(city: cityName)
            detailShowViewController.modalPresentationStyle = .fullScreen
            self.navigationController.present(detailShowViewController, animated: false)
        case .dismissDetailShowUIViewController:
            self.navigationController.dismiss(animated: false)
        }
    }

    private func configureDetailShowViewController(city: City) -> UINavigationController {
        let viewController = DetailShowUIViewController()
        let weatherRepository =  DefaultWeatherRepository(service: APIService())
        let detailShowUseCase = DetailShowUseCase(
            weatherRepository: weatherRepository
        )
        viewController.viewModel = DetailShowViewModel(
            detailShowUseCase: detailShowUseCase,
            imageCacheUseCase: self.imageCacheUseCase,
            coodinator: self, city: city
        )
        let navigationController = UINavigationController(rootViewController: viewController)

        return navigationController
    }
}

enum Event {

    enum View {

        case presentDetailShowUIViewController(cityName: City)
        case dismissDetailShowUIViewController
    }
}

