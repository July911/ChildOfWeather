import Foundation

struct City: Codable {
    
    let id: Int
    let name: String
    let state: String?
    let country: String
    let coord: Coord
}

extension City {
    static let EMPTY = City(id: .zero, name: "", state: "", country: "", coord: Coord(lon: 1, lat: 1))
}

struct Coord: Codable {
    let lon, lat: Double
}
