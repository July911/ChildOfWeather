import Foundation

final class DetailShowViewModel {
    
    let detailShowUseCase: DetailShowUseCase
    let coordinator: MainCoordinator
    let city: City
    let locationSearchUseCase: LocationSearchUseCase
    weak var delegate: DetailViewModelDelegate?
    
    init(detailShowUseCase: DetailShowUseCase, locationSearchUseCase: LocationSearchUseCase, coodinator: MainCoordinator, city: City) {
        self.detailShowUseCase = detailShowUseCase
        self.locationSearchUseCase = locationSearchUseCase
        self.coordinator = coodinator
        self.city = city
    }
    
    func createURL() -> String {
        let location = self.locationSearchUseCase.search(latitude: city.coord.lat, longitude: city.coord.lon)
        let strings = self.detailShowUseCase.weatherRepository.getURLFromLoaction(text: location ?? "")
        return strings
    }
}

protocol DetailViewModelDelegate: AnyObject {
    
}
