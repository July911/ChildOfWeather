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
    
    func createURL() {
        let location = self.locationSearchUseCase.search(latitude: city.coord.lat, longitude: city.coord.lon, completion: { [weak self] strings in
            let urlString = self?.detailShowUseCase.weatherRepository.getURLFromLoaction(text: strings ?? "")
            let replace = urlString?.replacingOccurrences(of: " ", with: "%20")
            let realURL = URL(string: replace!)!
          
            DispatchQueue.main.async {
               self?.delegate?.loadWebView(url: realURL)
            }
        })
    }
}

protocol DetailViewModelDelegate: AnyObject {
    func loadWebView(url: URL)
}
