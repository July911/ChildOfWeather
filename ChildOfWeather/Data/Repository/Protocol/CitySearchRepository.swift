import Foundation

protocol CitySearchRepository {
    func search(name: String) -> City?
}
