//
//  TimeHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/17.
//

import Foundation

class TimeHelper {
    func calcSecondsFromString(selectedUnitsValue: String, intSelectedDigitsValue: Int) -> Int {
        var timeIntervalSinceNow = 0
        if (selectedUnitsValue == "時間ごと") {
            timeIntervalSinceNow = (intSelectedDigitsValue) * 3600
            print("time interval is \(timeIntervalSinceNow)")
        } else if (selectedUnitsValue == "日ごと") {
            timeIntervalSinceNow = (intSelectedDigitsValue) * 86400
            print("time interval is \(timeIntervalSinceNow)")
        } else if (selectedUnitsValue == "週間ごと") {
            timeIntervalSinceNow = (intSelectedDigitsValue) * 604800
            print("time interval is \(timeIntervalSinceNow)")
        } else if (selectedUnitsValue == "ヶ月ごと") {
            timeIntervalSinceNow = (intSelectedDigitsValue) * 2592000
            print("time interval is \(timeIntervalSinceNow)")
        } else {
            print("selected units value is incorrect")
        }
        return timeIntervalSinceNow
    }
}
