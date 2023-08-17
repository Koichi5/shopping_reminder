//
//  NotificationManager.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/02.
//

import Foundation
import UserNotifications
import CoreLocation

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
        let content = UNMutableNotificationContent()
        content.title = "\(shoppingItem.name)の期限が迫っています。"
        content.body = "\(shoppingItem.name)を買いに行きましょう!"
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
    
    func sendLocationNotification (
        itemName: String,
        notificationLatitude: Double,
        notificationLongitude: Double,
        shoppingItemDocId: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = "\(itemName)を買い忘れないようにしましょう！"
        content.body = "\(itemName)の登録場所に到着しました。"
        content.sound = UNNotificationSound.default
        let center = CLLocationCoordinate2D(latitude: notificationLatitude, longitude: notificationLongitude)
        let region = CLCircularRegion(center: center, radius: 20, identifier: shoppingItemDocId)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: shoppingItemDocId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)  { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func deleteNotification(shoppingItemIndentifier: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: shoppingItemIndentifier)
    }
    
    func deleteAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func fetchAllRegisteredNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { array in
        }
    }
}
