//
//  AppDelegate.swift
//  Practical-Viren
//
//  Created by Viren Zalavadia on 12/11/24.
//

import UIKit
import CoreLocation

var locationAuthorizationStatus = CLAuthorizationStatus.notDetermined{
    willSet{
        if newValue != locationAuthorizationStatus{
            
        }
    }
}

var currentLocation : CLLocation?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var locationManager : CLLocationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.configureLocationManager()
        
        window?.makeKeyAndVisible()
        return true
    }

}


extension AppDelegate : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(locationAuthorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthorizationStatus = status
    }
}

extension AppDelegate{
    
    func configureLocationManager(){
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
    }
    
}
