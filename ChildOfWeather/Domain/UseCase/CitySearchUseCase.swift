//
//  NameSearchUseCase.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

final class CitySearchUseCase {
    
    let searchRepository: CitySearchRepository
    
    init(searchRepository: CitySearchRepository) {
        self.searchRepository = searchRepository
    }
}
