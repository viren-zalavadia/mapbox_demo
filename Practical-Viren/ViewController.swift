//
//  ViewController.swift
//  Practical-Viren
//
//  Created by Viren Zalavadia on 12/11/24.
//

import UIKit
import MapboxMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private var mapView: MapView!
    
    var isLocationComplete : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // observer
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { (notification) in
            self.checkForLocationService()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.perform(#selector(checkForLocationService), with: self, afterDelay: 1.0)
    }
    
    // Configure map to follow user location
    private func configureMap() {
        
        guard let location = currentLocation else {
            return
        }
        
        // Initialize MapView
        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            self?.mapView.location.options.puckType = .puck2D()
            self?.mapView.camera.ease(to: CameraOptions(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude,                                                 longitude: location.coordinate.longitude),
                                                        zoom: 2,
                                                        bearing: 0,
                                                        pitch: 0),
                                                        duration: 1.5)
        }
    }
    
}

//MARK: - Helper

extension ViewController {
    
    @objc private func checkForLocationService(){
        
        if locationAuthorizationStatus == .authorizedAlways || locationAuthorizationStatus == .authorizedWhenInUse {
            DispatchQueue.main.async {
                // once get location then setup camera
                self.selectCurrentLocation()
            }
        }
        else if locationAuthorizationStatus == .notDetermined{
            // not ask for permission
        }
        else{
            
            // decline permission
            self.showLocationPermissionAlert()
        }
    }
    
    @objc
    private func selectCurrentLocation(){
                
        guard let _ = currentLocation else {
            self.perform(#selector(selectCurrentLocation), with: self, afterDelay: 1.0)
            return
        }
        
        if !isLocationComplete {
            configureMap()
        }
        
        isLocationComplete = true
        
    }
    
    private func showLocationPermissionAlert(){
        
        let alertController = UIAlertController(title: "Update location access to check current location", message: "Select location and change to When in use or Always.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Update", style: .default) { (action) in
            
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:]
                                          , completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(action)
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
