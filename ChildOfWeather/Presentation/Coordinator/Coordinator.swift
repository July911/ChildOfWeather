import UIKit
import CoreLocation

final class MainCoordinator {

    private let navigationController: UINavigationController
    private let imageCacheUseCase = ImageCacheUseCase(
        imageProvideRepository: DefaultImageProvideRepository()
    )
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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

