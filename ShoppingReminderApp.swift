//
//  shopping_reminderApp.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/02.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        NotificationManager.instance.requestPermission()
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().delegate = self
        }
        return true
    }
}

@main
struct ShoppingReminderApp: App {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
//            LocationView()
//            MapView()
            if Auth.auth().currentUser != nil {
                HomeView()
            } else {
                EntryAuthView()
                    .onOpenURL{ url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .onAppear{
                        GIDSignIn.sharedInstance.restorePreviousSignIn{ user,error in
                            print("logged in as: \(user?.userID)")
                        }
                    }
            }
        }
    }
}
