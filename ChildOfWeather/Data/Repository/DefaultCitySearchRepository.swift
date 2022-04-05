import Foundation
import UIKit

final class DefaultCitySearchRepository: CitySearchRepository {
    
    var assetData: [City]?
    
    init() {
        self.assetData = decodedData()
    }
    
    func search(name: String) -> City? {
        return self.assetData?.filter { city in
            city.name == name
        }.first
    }
    
    private func decodedData() -> [City] {
        let assetData = NSDataAsset(name: "city.list")
        
        do {
            let data = try JSONDecoder().decode([City].self, from: assetData?.data ?? Data())
            return data
        } catch {
            return []
        }
    }
}
