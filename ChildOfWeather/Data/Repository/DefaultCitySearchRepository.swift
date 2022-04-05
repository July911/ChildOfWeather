import Foundation
import UIKit

final class DefaultCitySearchRepository: CitySearchRepository {
    
    var assetData: [City]?
    
    init() {
        self.assetData = decodedData()
    }
    
    func search(name: String) -> [City]? {
        return self.assetData?.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    private func decodedData() -> [City] {
        let assetData = NSDataAsset(name: "city.list")
        
        do {
            let data = try JSONDecoder().decode([City].self, from: assetData?.data ?? Data())
            let filtered = data.filter{ $0.country == "KR" }
            return filtered
        } catch {
            return []
        }
    }
}
