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
        viewController.viewModel = SearchViewModel(searchUseCase: self.searchUseCase, coodinator: self)
        self.navigationController.setViewControllers([viewController], animated: false)
    }

    func occuredViewEvent(with event: Event.View) {
        let projectAddView = DetailShowUIViewController()

        switch event {
        case .presentDetailShowUIViewController(let id):
            self.navigationController.present(projectAddView, animated: false)
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

        case presentDetailShowUIViewController(identifier: String)
        case dismissDetailShowUIViewController
    }
}

