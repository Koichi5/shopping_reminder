//
//  NotificationManager.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/02.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let instance: NotificationManager = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("Error requestiong authrization for notification: \(error.localizedDescription)")
            } else {
                print("Notification authrization granted: \(granted)")
            }
        }
    }
    
    func getNotificationStrring() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                print("not determined")
            case .denied:
                print("denied")
            case .authorized:
                print("authorized")
            case .provisional:
                print("provisional")
            case .ephemeral:
                print("ephemeral")
            @unknown default:
                fatalError()
            }
        }
    }
    
    func sendIntervalNotification(
        shoppingItem: ShoppingItem,
        shoppingItemDocId: String
    ) {
        print("Send interval notification fired")
        let content = UNMutableNotificationContent()
        content.title = "\(shoppingItem.name) is expiring"
        content.body = "Let's go to buy \(shoppingItem.name) ! The expire date of this alerm is \(shoppingItem.alermCycleSeconds). The created at date of this alerm is \(shoppingItem.addedAt)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(shoppingItem.alermCycleSeconds!), repeats: shoppingItem.isAlermRepeatOn ?? false)
        let request = UNNotificationRequest(
            identifier: shoppingItemDocId,
//            identifier: "identifier",
            content: content, trigger: trigger)
        print("Identifier of this notification is: \(request.identifier)")
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Error adding interval notification \(error.localizedDescription)")
            } else {
                print("Interval notification added successfully !")
            }
        }
    }
    
    func deleteNotification(shoppingItemIndentifier: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: shoppingItemIndentifier)
        print("Identifier of this notification is: \(shoppingItemIndentifier)")
        print("Notification successfully deleted")
    }
    
    func deleteAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        print("All notification successfully deleted")
    }
    
    func fetchAllRegisteredNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { array in
          print("Registered all notifications: \(array)")
        }
    }
}
