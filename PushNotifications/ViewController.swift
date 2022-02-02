//
//  ViewController.swift
//  PushNotifications
//
//  Created by Zolt Varga on 01/20/22.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - UI
    
    // 1. Create LN Button - timeInterval Trigger
    lazy var timeIntervalTriggerLNButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Local Notification with Time Interval", for: .normal)
        button.addTarget(self, action: #selector(tapScheduleLNTimeIntervalTrigger), for: .touchUpInside)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    // 2. Create LN Button - Calendar Trigger
    lazy var calendarTriggerLNButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Local Notification with Calendar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(tapScheduleLNCalendarTrigger), for: .touchUpInside)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    // 3. Cancel Local Notification Button
    lazy var cancelLocalNotificationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel Local Notification", for: .normal)
        button.addTarget(self, action: #selector(tapCancelLocalNotification), for: .touchUpInside)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    // 4. Print Active LN
    lazy var printActiveLNButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .magenta
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Print Active Local Notification", for: .normal)
        button.addTarget(self, action: #selector(tapPrintActiveLN), for: .touchUpInside)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    // MARK: - Private Variables
    
    private var notificationIdentifier = ""
    private var makeUniqNotification = 0
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupUI()
    }
    
    // MARK: - Local Notification Examples
    
    func scheduleLNTimeIntervalTrigger() {
        // 1. Create Local Notification and Add Content
        let content = UNMutableNotificationContent()
        content.title = "'Title': Local Notification 🙂"
        content.subtitle = "'Subtitle': TimeInterval"
        content.body = "'Body': Used 'timeInterval' to trigger it after X seconds"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "myActionCategoryIdentifier2"
        content.userInfo = ["customDataKey": "cusom_data_value"]
        content.threadIdentifier = "krco"
        
        // 2. Create Trigger and Configure the desired behaviour - Time Interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false) // Time trigger
        
        // Choose a random identifier, this is important if you want to be able to cancle the Notification
        makeUniqNotification = makeUniqNotification + 1
        notificationIdentifier = UUID().uuidString + "_" + "some_uniq_identifier" + makeUniqNotification.description // E.g. 123-abc_clock-alarm
        let request = UNNotificationRequest(identifier: notificationIdentifier,
                                            content: content,
                                            trigger: trigger)
        
        // 3. Create the Request
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleLNCalendarTrigger() {
        // 1. Create Local Notification and Add Content
        let content = UNMutableNotificationContent()
        content.title = "'Title': Local Notification 🙂"
        content.subtitle = "'Subtitle': Calendar"
        content.body = "'Body': Used 'DateComponents' to trigger it exactly at Time"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "myActionCategoryIdentifier"
        content.userInfo = ["customDataKey": "cusom_data_value"]
        content.threadIdentifier = "krco"
        
        // 2. Create Trigger and Configure the desired behaviour - Calendar
        var date = DateComponents()
        date.year = 2022
        date.month = 1
        date.day = 31
        date.hour = 20
        date.minute = 52
        date.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        // Choose a random identifier, this is important if you want to be able to cancle the Notification
        notificationIdentifier = UUID().uuidString + "_" + "some_uniq_identifier" + makeUniqNotification.description // E.g. 123-abc_clock-alarm
        let request = UNNotificationRequest(identifier: notificationIdentifier,
                                            content: content,
                                            trigger: trigger)
        
        // 3. Create the Request
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleLNLocationTrigger() {
        // 1. Create Local Notification and Add Content
        let content = UNMutableNotificationContent()
        content.title = "'Title': Local Notification 🙂"
        content.subtitle = "'Subtitle': Location"
        content.body = "'Body': Used 'region' to trigger when enter or exit"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "myActionCategoryIdentifier"
        content.userInfo = ["customDataKey": "cusom_data_value"]
        
        // 2. Create Trigger and Configure the desired behaviour - Location
        let location = CLLocationCoordinate2D(latitude: 45.255981,
                                              longitude: 19.844488)
        let region = CLCircularRegion(center: location,
                                      radius: 2,
                                      identifier: UUID().uuidString)
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false) // Location trigger
        
        // Choose a random identifier, this is important if you want to be able to cancle the Notification
        notificationIdentifier = UUID().uuidString + "_" + "some_uniq_identifier" // E.g. 123-abc_clock-alarm
        let request = UNNotificationRequest(identifier: notificationIdentifier,
                                            content: content,
                                            trigger: trigger)
        
        // 3. Create the Request
        UNUserNotificationCenter.current().add(request)
    }
    
    func getPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notifications) in
            print("\nℹ️ Number of pending notifications \(notifications.count)")
            print("Notifications: \(notifications)")
        })
    }
    
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func checkNotificationPermissions() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            switch settings.authorizationStatus {
                case .notDetermined: print("notDetermined")
                case .denied: print("denied")
                case .authorized: print("authorized")
                case .provisional: print("provisional")
                case .ephemeral: print("ephemeral")
                default: break
            }
        })
    }
}

// MARK: - Action
private extension ViewController {

    @objc private func tapScheduleLNTimeIntervalTrigger() {
        print("tapScheduleLNTimeIntervalTriggerLN")
        scheduleLNTimeIntervalTrigger()
    }
    
    @objc private func tapScheduleLNCalendarTrigger() {
        print("tapScheduleLNCalendarTrigger")
        scheduleLNCalendarTrigger()
    }
    
    @objc private func tapCancelLocalNotification() {
        print("tapCancelLocalNotification")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        notificationIdentifier = ""
    }
    
    @objc private func tapPrintActiveLN() {
        print("tapPrintActiveLN")
        getPendingNotifications()
    }
}


// MARK: - Setup UI
private extension ViewController {
    private func setupUI() {
        
        view.addSubview(timeIntervalTriggerLNButton)
        timeIntervalTriggerLNButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timeIntervalTriggerLNButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        timeIntervalTriggerLNButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeIntervalTriggerLNButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        
        view.addSubview(calendarTriggerLNButton)
        calendarTriggerLNButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        calendarTriggerLNButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        calendarTriggerLNButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendarTriggerLNButton.topAnchor.constraint(equalTo: timeIntervalTriggerLNButton.topAnchor, constant: 75).isActive = true
        
        view.addSubview(cancelLocalNotificationButton)
        cancelLocalNotificationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelLocalNotificationButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        cancelLocalNotificationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelLocalNotificationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        
        view.addSubview(printActiveLNButton)
        printActiveLNButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        printActiveLNButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        printActiveLNButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        printActiveLNButton.bottomAnchor.constraint(equalTo: cancelLocalNotificationButton.bottomAnchor, constant: -75).isActive = true
    }
}
