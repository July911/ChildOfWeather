import Foundation

protocol CitySearchRepository {
    
    var assetData: [City]? { get }
    
    func search(name: String) -> [City]?
}
