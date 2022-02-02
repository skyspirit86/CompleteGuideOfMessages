//
//  NotificationViewController.swift
//  PNContentExtension
//
//  Created by Zolt Varga on 02/01/22.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var mapUI: MKMapView!
    @IBOutlet weak var directionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 45.255977, longitude: 19.844413)
        mapUI.centerToLocation(initialLocation)
    }
    
    func didReceive(_ notification: UNNotification) {
        //self.label?.text = notification.request.content.body
    }
    
    @IBAction func tapDirectionButton(_ sender: Any) {
        print("tapDirectionButton")
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 500) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
