//
//  Int+Extension.swift
//  ChildOfWeather
//
//  Created by 조영민 on 2022/05/19.
//

import Foundation

extension Int {
    
    var toKoreanTime: String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DefaultDateformatter.shared.dateformatter
        formatter.dateFormat = "HH: mm"
        
        return formatter.string(from: time)
    }
}

