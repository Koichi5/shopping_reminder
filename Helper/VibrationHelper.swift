//
//  VibrationHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/09.
//

import Foundation
import UIKit
import AudioToolbox

class VibrationHelper: ObservableObject {
    @Published var isAllowedVibration: Bool = true
    func successVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    func errorVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    func warningVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
    }
    func lightVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    func mediumVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    func heavyVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    func feedbackVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
    func longVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        }
    }
    func firstSoundVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1102)) {}
        }
    }
    func secondSoundVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1519)) {}
        }
    }
    func thirdSoundVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1520)) {}
        }
    }
    func fourthSoundVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1521)) {}
        }
    }
    func threeTimesVibration() {
        if (isAllowedVibration) {
            print("Vibration Fired")
            for _ in 0...2 {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                sleep(1)
            }
        }
    }
    func noLimitVibration() {
        if (isAllowedVibration) {
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
