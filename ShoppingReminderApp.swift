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
import FirebaseAuth

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
//    @AppStorage("isDarkModeOn") private var isDarkModeOn = false
//    @AppStorage("isVibrationOn") private var isVibrationOn = true
//    @StateObject var vibrationHelper = VibrationHelper()
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
                EntryAuthView()
//            HomeView()
//                .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
        }
    }
}
