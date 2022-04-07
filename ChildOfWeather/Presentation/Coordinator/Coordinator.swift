import UIKit

final class MainCoordinator {

    private let navigationController: UINavigationController
    private lazy var searchUseCase = CitySearchUseCase(searchRepository: DefaultCitySearchRepository())
    private lazy var detailShowUseCase = DetailShowUseCase(weatherRepository: DefaultWeatherRepository(service: APICaller()))

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SearchViewController()
        let searchViewModel = SearchViewModel(searchUseCase: self.searchUseCase, coodinator: self)
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
        let locationSearchUseCase = LocationSearchUseCase()
        viewController.viewModel = DetailShowViewModel(detailShowUseCase: self.detailShowUseCase, locationSearchUseCase: locationSearchUseCase, coodinator: self, city: city)
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

