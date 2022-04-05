//
//  City.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

struct City: Codable {
    
    let id: Int
    let name, state, country: String
    let coord: Coord
}
