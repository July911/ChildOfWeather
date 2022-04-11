import UIKit

final class DefaultCitySearchRepository: CitySearchRepository {
    
    private var assetData: [City]?
    
    init() {
        self.assetData = sortCity()
    }
    
    func search(name: String) -> [City]? {
        return self.assetData?.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    func sortCity(by country: Country = .kr) -> [City] {
        let assetData = NSDataAsset(name: "city.list")
        
        do {
            let data = try JSONDecoder().decode([City].self, from: assetData?.data ?? Data())
            let filtered = data.filter{ $0.country == "\(country.description)" }
            return filtered
        } catch {
            return []
        }
    }
}

enum Country {
    case kr
    case eu
    case us
    
    var description: String {
        switch self {
        case .kr:
            return "KR"
        case .eu:
            return "EU"
        case .us:
            return "US"
        }
    }
}
