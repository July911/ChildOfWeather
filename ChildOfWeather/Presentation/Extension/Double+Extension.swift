//
//  DoubleExtension.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/05/19.
//

import Foundation

extension Double {
    
    var toCelsius: Double {
        let celsius = (self - 273.15)
        let droppedCelsius = String(celsius).prefix(5)
        
        return Double(droppedCelsius) ?? .zero
    }
}
