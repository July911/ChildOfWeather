import UIKit
import CoreLocation

final class MainCoordinator {

    private let navigationController: UINavigationController
    private let imageCacheUseCase = ImageCacheUseCase(
        imageProvideRepository: DefaultImageProvideRepository()
    )
    private let defaultLocationRepository = DefaultAddressSearchRepository(
        service: CLGeocoder()
    )
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SearchViewController()
        let searchUseCase = CitySearchUseCase(searchRepository: DefaultCitySearchRepository())
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase, coodinator: self)
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
        let locationSearchUseCase = LocationSearchUseCase(addressRepository: defaultLocationRepository)
        let detailShowUseCase = DetailShowUseCase(
            weatherRepository: DefaultWeatherRepository(service: APIService<WeatherInformation>())
        )
        viewController.viewModel = DetailShowViewModel(
            detailShowUseCase: detailShowUseCase,
            locationSearchUseCase: locationSearchUseCase,
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

