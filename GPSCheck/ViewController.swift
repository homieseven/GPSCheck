//
//  ViewController.swift
//  GPSCheck
//
//  Created by Vitali Usau on 10/29/16.
//  Copyright © 2016 Becoast. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latLabel: UILabel?
    @IBOutlet weak var longLabel: UILabel?
    @IBOutlet weak var horizontalLabel: UILabel?
    @IBOutlet weak var verticalLabel: UILabel?

    @IBOutlet weak var speedLabel: UILabel?
    @IBOutlet weak var courseLabel: UILabel?

    @IBOutlet weak var rateLabel: UILabel?
    
    var previousUpdateDate : Date?

    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.pausesLocationUpdatesAutomatically = false
        
        self.rateLabel?.text = "Wainting for GPS"
        UIApplication.shared.isIdleTimerDisabled = true  // do not want to sleep
        
        let currentStatus = CLLocationManager.authorizationStatus()
        switch currentStatus {
            
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            break
            
        case .authorizedWhenInUse:
            self.startLocationManager(locationManager: self.locationManager)
            break
            
        default :
            break
        }
    }
    
    
    func startLocationManager(locationManager: CLLocationManager) {
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocation delegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.startLocationManager(locationManager: self.locationManager)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let recentLocation = locations.last {
            self.flashRateLabel()
            let currentDate = Date()
            var timeDifference : Double
            if (self.previousUpdateDate != nil) {
                timeDifference = currentDate.timeIntervalSince(self.previousUpdateDate!)
                self.rateLabel?.text = String(format: "%.1f", Double(locations.count)/timeDifference)
            } else {
                self.rateLabel?.text = "0.0"
            }
            
            self.previousUpdateDate = currentDate
            
            let currentSpeed = recentLocation.speed > 0 ? recentLocation.speed * 3.6 : 0.0
            self.latLabel?.text = String(format: "%f", recentLocation.coordinate.latitude)
            self.longLabel?.text = String(format: "%f", recentLocation.coordinate.longitude)
            self.horizontalLabel?.text = String(format: "%.1f", recentLocation.horizontalAccuracy)
            self.verticalLabel?.text = String(format: "%.1f", recentLocation.verticalAccuracy)
            self.courseLabel?.text = String(format: "%f", recentLocation.course)
            self.speedLabel?.text = String(format: "%.1f", currentSpeed)
        }
    }
    
    // MARK: Custom methods
    func flashRateLabel () {
        self.rateLabel?.alpha = 1.0
        UIView.animate(withDuration: 0.4, animations: {
            self.rateLabel?.alpha = 0.4
        })
    }
   
}

