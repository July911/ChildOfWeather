//
//  ListViewModel.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation

final class SearchViewModel {
    
    let searchUseCase: CitySearchUseCase
    
    init(searchUseCase: CitySearchUseCase) {
        self.searchUseCase = searchUseCase
    }
}
