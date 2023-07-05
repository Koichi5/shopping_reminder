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
                     //                     open url: URL,
                     //                     options: [UIApplication.OpenURLOptionsKey: Any] = [:],
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
//        GIDSignIn.sharedInstance.restorePreviousSignIn() { user, error in
//            if error != nil || user == nil {
//                // Show the app's signed-out state.
//                print("Not sign-in")
//            }
//            else {
//                // Show the app's signed-in state.
//                if let user = user, let userID = user.userID {
//                    guard let idToken = user.idToken else {
//                        print("error occured during google sign in")
//                    }
//                    let accessToken = user.accessToken
//                    let credential = GoogleAuthProvider.credential(
//                      withIDToken: idToken.tokenString,
//                      accessToken: accessToken.tokenString
//                    )
//                    do {
//                        let result = try await Auth.auth().signIn(with: credential)
//                    }
//                    print("Already signed-in as :\(userID)")
//                }
//            }
//        }
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
            if Auth.auth().currentUser != nil {
                HomeView()
            } else {
                EntryAuthView()
                    .onOpenURL{ url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .onAppear{
                        GIDSignIn.sharedInstance.restorePreviousSignIn{ user,error in
                        }
                    }
            }
            //            IntroView()
        }
    }
}
