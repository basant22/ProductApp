//
//  AppDelegate.swift
//  ProductApp
//
//  Created by apple on 13/10/26.
//

import Foundation
import UserNotifications
import UIKit
class AppDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate{
    func applicationDidFinishLaunching(_ application: UIApplication) {
        requestForRemoteNotification()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map{ String(format: "%02.2hhx", $0)}.joined()
        print("APNs Device Token: \(tokenString)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    func requestForRemoteNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { grant, error in
            if grant{
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}
