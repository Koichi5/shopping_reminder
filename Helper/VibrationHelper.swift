//
//  VibrationHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/09.
//

import Foundation
import AudioToolbox
import UIKit
import SwiftUI

class VibrationHelper: ObservableObject {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    func successVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    func errorVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    func warningVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
    }
    func lightVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    func mediumVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    func heavyVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    func feedbackVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
    func longVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        }
    }
    func firstSoundVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1102)) {}
        }
    }
    func secondSoundVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1519)) {}
        }
    }
    func thirdSoundVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1520)) {}
        }
    }
    func fourthSoundVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1521)) {}
        }
    }
    func threeTimesVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            for _ in 0...2 {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                sleep(1)
            }
        }
    }
    func noLimitVibration() {
        if (userDefaultsHelper.isVibrationAllowed) {
            print("Vibration Fired")
            func makeVibrationNoLimit() {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                    makeVibrationNoLimit()
                    sleep(1)
                }
            }
        }
    }
}
