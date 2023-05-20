//
//  VibrationHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/09.
//

import Foundation
import UIKit
import AudioToolbox

class VibrationHelper {
    func successVibration() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    func errorVibration() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    func warningVibration() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    func lightVibration() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    func mediumVibration() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    func heavyVibration() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    func feedbackVibration() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    func longVibration() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
    }
    func firstSoundVibration() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1102)) {}
    }
    func secondSoundVibration() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1519)) {}
    }
    func thirdSoundVibration() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1520)) {}
    }
    func fourthSoundVibration() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1521)) {}
    }
    func threeTimesVibration() {
        for _ in 0...2 {
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
            sleep(1)
        }
    }
    func noLimitVibration() {
        func makeVibrationNoLimit() {
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                makeVibrationNoLimit()
                sleep(1)
            }
        }
    }
}
