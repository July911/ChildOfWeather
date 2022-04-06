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
//            let url = self?.detailShowUseCase.weatherRepository.getURLFromLoaction(text: strings ?? "")
//            let realURL = URL(string: url ?? "https://www.google.com")
            let testURL = "https://www.google.com/search?q=swift"
            let url = URL(string: testURL)
            DispatchQueue.main.async {
               self?.delegate?.loadWebView(url: url!)
            }
        })
    }
}

protocol DetailViewModelDelegate: AnyObject {
    func loadWebView(url: URL)
}
