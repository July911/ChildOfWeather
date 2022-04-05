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
        let detailShowView = DetailShowUIViewController()

        switch event {
        case .presentDetailShowUIViewController(let cityName):
            self.navigationController.present(detailShowView, animated: false)
        case .dismissDetailShowUIViewController:
            self.navigationController.dismiss(animated: false)
        }
    }

    private func configureDetailShowViewController() -> UINavigationController {
        let viewController = DetailShowUIViewController()
        viewController.viewModel = DetailShowViewModel(detailShowUseCase: self.detailShowUseCase, coodinator: self)
        let navigationController = UINavigationController(rootViewController: viewController)

        return navigationController
    }
}


enum Event {

    enum View {

        case presentDetailShowUIViewController(cityName: String)
        case dismissDetailShowUIViewController
    }
}

