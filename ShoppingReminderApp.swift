//
//  shopping_reminderApp.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/02.
//

import SwiftUI

import SwiftUI
import FirebaseCore
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
//                     open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey: Any] = [:],
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        NotificationManager.instance.requestPermission()
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().delegate = self
        }
        return true
//        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct ShoppingReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
//            SideMenuContentView()
            EntryAuthView()
//            UrlButton(systemName: "app.gift", buttonText: "Visit My App", sourceUrl: "https://play.google.com/store/apps/details?id=com.koichi.techjourney&hl=ja")
//            MemoView()
//            IntroSliderView()
        }
    }
}
