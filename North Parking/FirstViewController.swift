//
//  FirstViewController.swift
//  North Parking
//
//  Created by Henry Macht on 9/18/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    // VARS
    var parkButton = UIButton()
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let screenSize = UIScreen.main.bounds
    
    // Reference to server
    var ref: DatabaseReference!
    
    // Create UI
    func createParkButton(){
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        
        // change hard code --
        let buttonWidth = CGFloat(430)
        let buttonHeight = CGFloat(300)
        
        let image = UIImage(named: "Group 985") as UIImage?
        parkButton.frame = CGRect(x: screenWidth/2 - buttonWidth/2, y: screenHeight - screenHeight/2.75, width: buttonWidth, height: buttonHeight)
        parkButton.setImage(image, for: .normal)
        parkButton.addTarget(self, action: "park", for: UIControlEvents.touchUpInside)
        self.view.addSubview(parkButton)
        
        
    }
    
    func createBanner(){
        let screenWidth = CGFloat(screenSize.width)
        let image: UIImage = UIImage(named: "Rectangle 6715")!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: view.center.x - screenWidth/2, y: 0, width: screenWidth, height: 100)
        self.view.addSubview(imageView)

    }
    
    // create circle
    func createCircle(){
        let center = view.center
        let adjectedCenter = CGPoint(x: center.x, y: center.y - 30)
        let circlePath = UIBezierPath(arcCenter: adjectedCenter, radius: 140, startAngle: -CGFloat.pi / 2, endAngle: 2*CGFloat.pi, clockwise: true)
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
        trackLayer.lineWidth = 20
        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor(red: 122.0/255.0, green: 203.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
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
        createCircle()
        createBanner()
        
        self.ref = Database.database().reference()
    }

    // ACTIONS
    
    @objc func park() {
        print("PARK")
        
        // animate scircle
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
        self.ref.child("test").childByAutoId().setValue(["name": "Toby"])
        
    }


}

