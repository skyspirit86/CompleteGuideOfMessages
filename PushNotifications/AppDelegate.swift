//
//  AppDelegate.swift
//  PushNotifications
//
//  Created by Zolt Varga on 01/20/22.
//

import UIKit
import UserNotifications // 1. Import

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("🔵 \(#function)")
        
        registerCustomActionCategories()
        registerForPushNotifications()
        
        checkForSilentPushNotification(launchOptions: launchOptions)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("🔵 \(#function)")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: - Remote Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: - Register
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // let token = deviceToken.map { (String(format: "%02.2hhx", $0)) }.joined()
        let token = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()
        print("🆔 \(#function) Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("📩 \(#function)")
    }
    
    // MARK: - Receive
    
    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("📩 \(#function)")
        // when app is open and in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("\n📩 \(#function)")
        
        // 1. Get the Notification Identifier
        let identifier = response.notification.request.identifier
        print("🆔 \(#function) Id: \(identifier)")
        
        // 2. Check for Custom Actions to Handle
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier: print("Default Action identifier") // the user swiped to unlock
        case UNNotificationDismissActionIdentifier: print("Dismiss Action identifier") // the user dismissed the Notification
        case "showMeMoreIdentifier": print("👆 showMeMoreIdentifier")
        case "snoozeIdentifier": print("👆 snoozeIdentifier")
        case "deleteIdentifier": print("👆 deleteIdentifier")
        case "likeIdentifier": print("👆 likeIdentifier from Service Extension")
        case "shareIdentifier": print("👆 shareIdentifier from Service Extension")
                
        default: print("Switch default")
        }
        
        
        // 3. Check for Custom data passed with Notification
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customDataKey"] as? String {
            print("Custom data received: \(customData)")
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    // MARK: - Customiszation
    
    func registerForPushNotifications() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        // let options: UNAuthorizationOptions = [.provisional]
        UNUserNotificationCenter.current().requestAuthorization(options: [options]) { granted, _ in
            print("✅ \(#function) Permission granted: \(granted)")
            guard granted else { return }
            
            // self.setupActionableNotifications()
            
            self.getNotificationSettings()
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("ℹ️ Notification settings: \(settings)")
        }
    }
    
    func registerCustomActionCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self // Must call where UNUserNotificationCenterDelegate is
        
        let showMeMoreAction = UNNotificationAction(identifier: "showMeMoreIdentifier",
                                        title: "Show me more",
                                        options: [.foreground])
        let snoozeAction = UNNotificationAction(identifier: "snoozeIdentifier", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "deleteIdentifier", title: "Delete", options: [.destructive])
        let category1 = UNNotificationCategory(identifier: "myActionCategoryIdentifier1", actions: [showMeMoreAction], intentIdentifiers: [])
        let category2 = UNNotificationCategory(identifier: "myActionCategoryIdentifier2", actions: [snoozeAction, deleteAction], intentIdentifiers: [])
        
        center.setNotificationCategories([category1, category2])
    }
    
    func setupActionableNotifications() {
        print("🔧 \(#function)")
        // 1. Create Actions / Buttons
        let acceptAction = UNNotificationAction(identifier: "acceptIdentifier",
                                              title: "✅ Accept",
                                              options: [.foreground])
        let rejectAction = UNNotificationAction(identifier: "rejectIdentifier",
                                                title: "❌ Reject",
                                                options: [])
        
        // 2. Create Category
        let newsCategory = UNNotificationCategory(identifier: "newsCategoryIdentifier",
                                                  actions: [acceptAction, rejectAction],
                                                  intentIdentifiers: [],
                                                  options: [])
        
        // 3. Register Category
        UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
    }
    
    func checkForSilentPushNotification(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        
        // 1. Cehck for Notification
        if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
            // 2. Process if needed
            
            // 3. Check for Silent Push Notifications
            if aps["content-available"] as? Int == 1 {
                print("🤫 \(#function) Silent")
            }
        }
    }
}
