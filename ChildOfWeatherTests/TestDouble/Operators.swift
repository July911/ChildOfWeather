//
//  Operators.swift
//  ChildOfWeatherTests
//
//  Created by 조영민 on 2022/06/02.
//

import RxSwift
import RxTest
import Nimble
import RxNimble

public func equal<Void>(_ expectedValue: Void?) -> Predicate<Void> {
    return Predicate.define("equal <\(stringify(expectedValue))>") { actualExpression, msg in
        let actualValue = try actualExpression.evaluate()
        switch (expectedValue, actualValue) {
        case (nil, _?):
            return PredicateResult(status: .fail, message: msg.appendedBeNilHint())
        case (nil, nil), (_, nil):
            return PredicateResult(status: .fail, message: msg)
        default:
            var isEqual = false

            if String(describing: expectedValue).count != 0, String(describing: expectedValue) == String(describing: actualValue) {
                isEqual = true
            }
            return PredicateResult(bool: isEqual, message: msg)
        }
    }
}
