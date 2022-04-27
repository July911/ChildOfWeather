import UIKit
import RxRelay
import RxSwift

final class DefaultCitySearchRepository: CitySearchRepository {
    
    private let assetData = BehaviorRelay<[City]>(value: [])
    
    init() {
        self.fetchCityList()
    }
    
    func search(name: String?) -> Observable<[City]> {
        
        guard let name = name, name != ""
        else {
            self.fetchCityList()
            return self.assetData.asObservable()
        }
        let filteredCity = assetData.value.filter { $0.name.hasPrefix(name) }
        
        return Observable<[City]>.just(filteredCity)
    }
    
    func extractCities(by country: Country = .kr) -> BehaviorRelay<[City]> {
        return self.assetData
    }
    
    private func fetchCityList(by country: Country = .kr) {
        let assetData = NSDataAsset(name: "city.list")
        let data = try? JSONDecoder().decode([City].self, from: assetData?.data ?? Data())
        let filtered = data?.filter{ $0.country == "\(country.description)" }
        
        self.assetData.accept(filtered ?? [])
    }
}

