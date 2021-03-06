import UIKit

final class DefaultCitySearchRepository: CitySearchRepository {
    
    private var assetData: [City]?
    
    init() {
        self.assetData = self.fetchCityList()
    }
    
    func search(name: String?) -> [City]? {
        
        guard let cities = self.assetData
        else {
            return nil
        }
        
        guard let name = name, name != ""
        else {
            return self.assetData
        }
        
        let filteredCity = cities.filter { $0.name.localized.hasPrefix(name) }
        
        return filteredCity
    }
    
    func extractCities(by country: Country = .kr) -> [City] {
        return self.assetData ?? []
    }
    
    private func fetchCityList(by country: Country = .kr) -> [City] {
        let assetData = NSDataAsset(name: "city.list")
        let data = try? JSONDecoder().decode([City].self, from: assetData?.data ?? Data())
        let filtered = data?.filter{ $0.country == "\(country.description)" }
        
        return filtered ?? []
    }
}

