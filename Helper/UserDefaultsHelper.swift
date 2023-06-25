//
//  UserDefaults.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/11.
//

import Foundation

class UserDefaultsHelper: ObservableObject {
    @Published var isVibrationAllowed: Bool {
        didSet {
            UserDefaults.standard.set(isVibrationAllowed, forKey: "isVibrationAllowed")
        }
    }
    @Published var isDarkModeOn: Bool {
        didSet {
            UserDefaults.standard.set(isDarkModeOn, forKey: "isDarkModeOn")
        }
    }
    
//    init(isVibrationAllowed: Bool, isDarkModeOn: Bool) {
//        self.isVibrationAllowed = isVibrationAllowed
//        self.isDarkModeOn = isDarkModeOn
//    }
    init() {
        isVibrationAllowed = UserDefaults.standard.bool(forKey: "isVibrationAllowed") ?? true
        isDarkModeOn = UserDefaults.standard.bool(forKey: "isDarkModeOn") ?? false
        print("current isDarkModeOn is: \(isDarkModeOn)")
    }
}
