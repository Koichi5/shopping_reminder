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
    
    func sendIntervalNotification(intervalSeconds: Double) {
        print("Send interval notification fired")
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Local Notification Test"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalSeconds, repeats: false)
        let request = UNNotificationRequest(identifier: "notification01", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func sendCalenderNotification(shoppingItem: ShoppingItem) {
        print("Send calender notification fired")
        let content = UNMutableNotificationContent()
        content.title = "\(shoppingItem.name) is expiring"
        content.body = "Let's go to buy \(shoppingItem.name) ! The expire date of this alerm is \(shoppingItem.expirationDate). The created at date of this alerm is \(shoppingItem.addedAt)"
        content.sound = UNNotificationSound.default
        
        let calender = Calendar(identifier: .gregorian)
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: shoppingItem.expirationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: shoppingItem.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Error sending calendar notification: \(error.localizedDescription)")
            } else {
                print("Calendar notification send successfully.")
            }
        }
    }
}
