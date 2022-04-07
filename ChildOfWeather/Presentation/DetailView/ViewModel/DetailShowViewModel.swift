import Foundation

final class DetailShowViewModel {
    
    let detailShowUseCase: DetailShowUseCase
    let coordinator: MainCoordinator
    let city: City
    let locationSearchUseCase: LocationSearchUseCase
    weak var delegate: DetailViewModelDelegate?
    
    init(
        detailShowUseCase: DetailShowUseCase,
         locationSearchUseCase: LocationSearchUseCase,
        coodinator: MainCoordinator,
        city: City
    ) {
        self.detailShowUseCase = detailShowUseCase
        self.locationSearchUseCase = locationSearchUseCase
        self.coordinator = coodinator
        self.city = city
    }
    
    func createURL() {
        self.locationSearchUseCase.searchLocation(
            latitude: city.coord.lat,
            longitude: city.coord.lon,
            completion: { [weak self] strings in
            let urlString = self?.detailShowUseCase.weatherRepository.getURLFromLoaction(text: strings ?? "")
                
            guard let replace = urlString?.replacingOccurrences(of: " ", with: "%20")
                else {
                return
            }
            guard let url = URL(string: replace)
                else {
                return
            }
            
            DispatchQueue.main.async {
                self?.delegate?.loadWebView(url: url)
            }
        })
    }
}

protocol DetailViewModelDelegate: AnyObject {
    func loadWebView(url: URL)
}
