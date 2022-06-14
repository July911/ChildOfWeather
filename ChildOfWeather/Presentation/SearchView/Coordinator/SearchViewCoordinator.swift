import UIKit
import CoreLocation
import RxSwift

final class SearchViewCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    private let imageCacheUseCase: ImageCacheUseCase
    private let navigationController: UINavigationController
    
    init(imageCacheUseCase: ImageCacheUseCase) {
        self.imageCacheUseCase = imageCacheUseCase
        self.navigationController = .init()
    }

    func start() -> UINavigationController {
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
        
        return self.navigationController
    }

    func occuredViewEvent(with event: Event.View) {

        switch event {
        case .presentDetailShowUIViewController(let city):
            let detailWeatherViewController = self.configureDetailShowViewController(city: city)
            detailWeatherViewController.modalPresentationStyle = .fullScreen
            self.navigationController.present(detailWeatherViewController, animated: false)
        case .dismissDetailShowUIViewController:
            self.navigationController.dismiss(animated: false)
        }
    }

    private func configureDetailShowViewController(city: City) -> UINavigationController {
        let viewController = DetailWeatherViewController()
        let weatherRepository =  DefaultWeatherRepository(
            service: URLSessionService()
        )
        let detailShowUseCase = DetailWeatherFetchUseCase(
            weatherRepository: weatherRepository
        )
        viewController.viewModel = DetailWeatherViewModel(
            detailShowUseCase: detailShowUseCase,
            imageCacheUseCase: self.imageCacheUseCase,
            coodinator: self, city: city
        )
        let navigationController = UINavigationController(
            rootViewController: viewController
        )

        return navigationController
    }
}

enum Event {

    enum View {

        case presentDetailShowUIViewController(city: City)
        case dismissDetailShowUIViewController
    }
}

