//
//  CitySearchRepository.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

protocol CitySearchRepository {
    func search(name: String) -> City?
}
