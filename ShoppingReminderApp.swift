//
//  shopping_reminderApp.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/02.
//

import SwiftUI

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        NotificationManager.instance.requestPermission()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

@main
struct ShoppingReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
//            SideMenuContentView()
            EntryAuthView()
//            MemoView()
        }
    }
}
