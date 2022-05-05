import Foundation

struct City: Decodable, Hashable {
    
    let id: Int
    let name: String
    let state: String?
    let country: String
    let coord: Coord
}

extension City {
    static let EMPTY = City(id: .zero, name: "", state: "", country: "", coord: Coord(lat: 1, lon: 1))
}

struct Coord: Codable {
    let lat, lon: Double
}
