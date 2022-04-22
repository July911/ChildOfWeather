import UIKit
import RxRelay
import RxSwift

final class DefaultCitySearchRepository: CitySearchRepository {
    
    private var assetData: BehaviorRelay<[City]>?
    private let bag = DisposeBag()
    
    init() {
        self.assetData = sortCity()
    }
    
    func search(name: String) {
        guard let searchData = (assetData?.value.filter { $0.name == name })
        else {
            return
        }
        
        assetData?.accept(searchData)
    }
    
    func sortCity(by country: Country = .kr) -> BehaviorRelay<[City]> {
        let assetData = NSDataAsset(name: "city.list")
        let data = try? JSONDecoder().decode([City].self, from: assetData?.data ?? Data())
        let filtered = data?.filter{ $0.country == "\(country.description)" }
        
        return BehaviorRelay<[City]>(value: filtered ?? [])
    }
}

