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
    var hullButton = UIButton()
    var lowellButton = UIButton()
    var closeButton = UIButton()
    let shapeLayer = CAShapeLayer()
    let shapeLayer2 = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let screenSize = UIScreen.main.bounds
    var percentLabel = UILabel()
    var whiteSquare = UIImageView()
    var popUpBlackSquare = UIImageView()
    var canPressPark = true
    
    var totalPercent: CGFloat = 0
    var totalSpots: CGFloat = 100
    var takenSpots: CGFloat = 0
    
    var hullTotalPercent: CGFloat = 0
    var hullTotalSpots: CGFloat = 80
    var hullTakenSpots: CGFloat = 0
    
    var lowellTotalPercent: CGFloat = 0
    var lowellTotalSpots: CGFloat = 20
    var lowellTakenSpots: CGFloat = 0
    
    
    // Reference to server
    var ref: DatabaseReference!
    
    
    // Create UI
    func createClosePopupBtn(){
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        let center = view.center
        // change hard code --
        let buttonWidth = CGFloat(50)
        let buttonHeight = CGFloat(50)
        
        let image = UIImage(named: "Group 994") as UIImage?
        closeButton.frame = CGRect(x: whiteSquare.frame.width - 10 - buttonWidth, y: 10, width: buttonWidth, height: buttonHeight)
        closeButton.setImage(image, for: .normal)
        closeButton.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: "closePopup", for: UIControlEvents.touchUpInside)
        closeButton.layer.zPosition = 2
        self.whiteSquare.addSubview(closeButton)
    }
    func createHullButton(){
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        let center = view.center
        // change hard code --
        let buttonWidth = CGFloat(200)
        let buttonHeight = CGFloat(70)
        
        let image = UIImage(named: "Group 995") as UIImage?
        hullButton.frame = CGRect(x: whiteSquare.frame.width/2 - buttonWidth / 2, y: whiteSquare.frame.height/2 - buttonHeight - 5, width: buttonWidth, height: buttonHeight)
        hullButton.setImage(image, for: .normal)
        hullButton.contentMode = .scaleAspectFit
        hullButton.addTarget(self, action: "hullPark", for: UIControlEvents.touchUpInside)
        hullButton.layer.zPosition = 3
        self.whiteSquare.addSubview(hullButton)
    }
    func createLowellButton(){
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        let center = view.center
        // change hard code --
        let buttonWidth = CGFloat(200)
        let buttonHeight = CGFloat(70)
        
        let image = UIImage(named: "Group 996") as UIImage?
        lowellButton.frame = CGRect(x: whiteSquare.frame.width/2 - buttonWidth / 2, y: whiteSquare.frame.height/2 + 5, width: buttonWidth, height: buttonHeight)
        lowellButton.setImage(image, for: .normal)
        lowellButton.contentMode = .scaleAspectFit
        lowellButton.addTarget(self, action: "lowellPark", for: UIControlEvents.touchUpInside)
        lowellButton.layer.zPosition = 3
        self.whiteSquare.addSubview(lowellButton)
    }
    func createWhiteSquare(){
        let center = view.center
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        let image: UIImage = UIImage(named: "Rectangle 6757")!
        whiteSquare = UIImageView(image: image)
        whiteSquare.frame = CGRect(x: center.x - (screenWidth - 10)/2, y: screenHeight, width: screenWidth - 10, height: screenHeight / 2.5)
        whiteSquare.layer.zPosition = 2
        whiteSquare.isUserInteractionEnabled = false
        self.view.addSubview(whiteSquare)
        UIView.animate(withDuration: 0.5, animations: {
            self.whiteSquare.frame.origin.y -= (screenHeight/2.5 + 5)
        }, completion: {finished in
            self.parkButton.removeFromSuperview()
            self.whiteSquare.isUserInteractionEnabled = true
            
        })
    }
    func createBlackBackground(){
        let center = view.center
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        popUpBlackSquare.backgroundColor = .black
        popUpBlackSquare.alpha = 0.0
        popUpBlackSquare.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        popUpBlackSquare.center = center
        popUpBlackSquare.layer.zPosition = 1
        self.view.addSubview(popUpBlackSquare)
        UIView.animate(withDuration: 0.5, animations: {
            self.popUpBlackSquare.alpha = 0.5
        }, completion: nil)
    }
    func createPopUp(){
        self.tabBarController?.tabBar.layer.zPosition = -1
        createBlackBackground()
        createWhiteSquare()
        createHullButton()
        createLowellButton()
        createClosePopupBtn()
    }
    func createPercentLabel(){
        let center = view.center
        let adjectedCenter = CGPoint(x: center.x, y: center.y - 30)
        let customFont = UIFont(name: "CeraRoundProDEMO-Black", size: 50)
        percentLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        percentLabel.textAlignment = .center
        percentLabel.center = adjectedCenter
        percentLabel.font = customFont
        percentLabel.text = "\(totalPercent)%"
        self.view.addSubview(percentLabel)
    }
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
        
        shapeLayer2.path = circlePath.cgPath
        shapeLayer2.strokeColor = UIColor(red: 82.0/255.0, green: 106.0/255.0, blue: 246.0/255.0, alpha: 1.0).cgColor
        shapeLayer2.lineWidth = 20
        shapeLayer2.lineCap = kCALineCapRound
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.strokeEnd = 0
        view.layer.addSublayer(shapeLayer2)
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
        createPercentLabel()
        
        
        self.ref = Database.database().reference()
        
    }
    
    // ACTIONS
    func animateCircles(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = lowellTotalPercent*0.8
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        basicAnimation.toValue = hullTotalPercent*0.8
        shapeLayer2.add(basicAnimation, forKey: "urSoBasic")
    }
    func calculatePercent(streetPercent: inout CGFloat, streetTotal: inout CGFloat, streetTakenSpots: inout CGFloat){
        streetTakenSpots += 1
        streetPercent = streetTakenSpots / streetTotal
        
        
    }
    func calculateTotalPercent(){
        print("\(takenSpots) -----")
        takenSpots = hullTakenSpots + lowellTakenSpots
        percentLabel.text = "\(Int((takenSpots/totalSpots)*100))%"
    }
    
    @objc func park() {
        print("PARK")
        
        // animate scircle
        if canPressPark{
            createPopUp()
            canPressPark = false
        }
        
        
        self.ref.child("test").childByAutoId().setValue(["name": "Toby"])
        
    }
    @objc func hullPark() {
        print("Hull")
        if hullTakenSpots < hullTotalSpots{
            calculatePercent(streetPercent: &hullTotalPercent, streetTotal: &hullTotalSpots, streetTakenSpots: &hullTakenSpots)
            animateCircles()
            closePopupWindow()
            calculateTotalPercent()
        }
    }
    @objc func lowellPark() {
        print("Lowell")
        if lowellTakenSpots < lowellTotalSpots{
            calculatePercent(streetPercent: &lowellTotalPercent, streetTotal: &lowellTotalSpots, streetTakenSpots: &lowellTakenSpots)
            animateCircles()
            closePopupWindow()
            calculateTotalPercent()
        }
    }
    func closePopupWindow(){
        createParkButton()
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.whiteSquare.frame.origin.y += (self.screenSize.height/2.5 + 5)
            self.popUpBlackSquare.alpha = 0.0
        }, completion: {finished in
            self.hullButton.removeFromSuperview()
            self.lowellButton.removeFromSuperview()
            self.whiteSquare.removeFromSuperview()
            self.popUpBlackSquare.removeFromSuperview()
            self.tabBarController?.tabBar.layer.zPosition = 0
            self.parkButton.isUserInteractionEnabled = true
            self.canPressPark = true
            // the code you put here will be executed when your animation finishes, therefore
            // call your function here
        })
    }
    
    @objc func closePopup() {
        print("close")
        closePopupWindow()
    }
    
    
}
