//
//  DefaultCitySearchRepository.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/04/05.
//

import Foundation
import UIKit

final class DefaultCitySearchRepository: CitySearchRepository {
    
    var assetData: [City]?
    
    init(assetData: NSDataAsset) {
        self.assetData = decodedData()
    }
    
    func search(name: String) -> City? {
        return self.assetData?.filter { city in
            city.name == name
        }.first
    }
    
    private func decodedData() -> [City] {
        let assetData = NSDataAsset(name: "city.list")
        
        do {
            let data = try JSONDecoder().decode([City].self, from: assetData?.data ?? Data())
            return data
        } catch {
            return []
        }
    }
}
