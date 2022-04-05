import Foundation

struct City: Codable {
    
    let id: Int
    let name, state, country: String
    let coord: Coord
}
