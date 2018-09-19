//
//  FirstViewController.swift
//  North Parking
//
//  Created by Henry Macht on 9/18/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    // VARS
    var parkButton = UIButton()
    
    let screenSize = UIScreen.main.bounds
    
    
    
    // Create UI
    
    func createParkButton(){
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        let buttonWidth = CGFloat(430)
        let buttonHeight = CGFloat(300)
        
        let image = UIImage(named: "Group 985") as UIImage?
        parkButton.frame = CGRect(x: screenWidth/2 - buttonWidth/2, y: screenHeight/2 - buttonHeight/2, width: buttonWidth, height: buttonHeight)
        parkButton.setImage(image, for: .normal)
        parkButton.addTarget(self, action: "park", for: UIControlEvents.touchUpInside)
        self.view.addSubview(parkButton)
    }
    
    
    // LOCATION
    
    let locationManager = CLLocationManager()
    
    func locationSetup(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // called to pulll gps data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetup()
        createParkButton()
        
        
        
        
    }

    // ACTIONS
    
    @objc func park() {
        print("PARK")
    }


}

