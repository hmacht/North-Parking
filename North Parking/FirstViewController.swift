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
    
    let screenSize = UIScreen.main.bounds
    
    // VARS
    
    // Buttons
    var parkButton = UIButton()
    var hullButton = UIButton()
    var lowellButton = UIButton()
    var closeButton = UIButton()
    var settingsButton = UIButton()
    var learnButton = UIButton()
    
    // Layers
    let shapeLayer = CAShapeLayer()
    let shapeLayer2 = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    // Labels
    var dashboardLabel = UILabel()
    var percentLabel = UILabel()
    
    // Image views
    var whiteSquare = UIImageView()
    var popUpBlackSquare = UIImageView()
    var key = UIImageView()
    var logo = UIImageView()
    var banner = UIImageView()
    var status = UIImageView()
    
    // Bools
    var canPressPark = true
    
    // Floats
    var circleRadius: CGFloat = 0
    
    var totalPercent: CGFloat = 0
    var totalSpots: CGFloat = 83
    var takenSpots: CGFloat = 0
    
    var hullTotalPercent: CGFloat = 0
    var hullTotalSpots: CGFloat = 53
    var hullTakenSpots: CGFloat = 0
    
    var lowellTotalPercent: CGFloat = 0
    var lowellTotalSpots: CGFloat = 30
    var lowellTakenSpots: CGFloat = 0
    
    
    // Reference to server
    var ref: DatabaseReference!
    
    // Create UI
    func createStatusImg(){
        let center = view.center
        let image: UIImage = UIImage(named: "Group 987")!
        status = UIImageView(image: image)
        status.frame = CGRect(x: 0, y: 0, width: 65, height: 30)
        status.center = CGPoint(x: screenSize.width - (status.frame.width/2) - 10, y: dashboardLabel.center.y)
        status.contentMode = .scaleAspectFit
        self.view.addSubview(status)
    }
    
    func createDashLabel(){
        let center = view.center
        let customFont = UIFont(name: "CeraRoundProDEMO-Black", size: 31)
        dashboardLabel.frame = CGRect(x: 20, y: 0, width: 200, height: 100)
        dashboardLabel.textAlignment = .left
        dashboardLabel.center.y = banner.center.y + banner.frame.height/2 + 40
        dashboardLabel.font = customFont
        dashboardLabel.text = "Dashboard"
        self.view.addSubview(dashboardLabel)
    }
    
    func createLogo(){
        let center = view.center
        let image: UIImage = UIImage(named: "Group 988")!
        logo = UIImageView(image: image)
        logo.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        logo.center = CGPoint(x: center.x, y: banner.center.y + 10)
        logo.contentMode = .scaleAspectFit
        self.view.addSubview(logo)
    }
    
    func createSettingsButton(){
        // change hard code --
        let buttonWidth = CGFloat(50)
        let buttonHeight = CGFloat(50)
        
        let image = UIImage(named: "Group 990") as UIImage?
        settingsButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        settingsButton.center = CGPoint(x: logo.center.x - screenSize.width/3, y: logo.center.y)
        settingsButton.setImage(image, for: .normal)
        settingsButton.contentMode = .scaleAspectFit
        settingsButton.addTarget(self, action: #selector(FirstViewController.goToSettings), for: UIControlEvents.touchUpInside)
        settingsButton.layer.zPosition = 3
        self.view.addSubview(settingsButton)
    }
    
    func createLearnButton(){
        // change hard code --
        let buttonWidth = CGFloat(50)
        let buttonHeight = CGFloat(50)
        
        let image = UIImage(named: "Group 989") as UIImage?
        learnButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        learnButton.center = CGPoint(x: logo.center.x + screenSize.width/3, y: logo.center.y)
        learnButton.setImage(image, for: .normal)
        learnButton.contentMode = .scaleAspectFit
        learnButton.addTarget(self, action: #selector(FirstViewController.goToHowto), for: UIControlEvents.touchUpInside)
        learnButton.layer.zPosition = 3
        self.view.addSubview(learnButton)
    }
    
    // This is for the popup screen
    func createKey(){
        let center = view.center
        let image: UIImage = UIImage(named: "Group 991")!
        key = UIImageView(image: image)
        key.frame = CGRect(x: 0, y: 0, width: 130, height: 30)
        key.center = CGPoint(x: center.x, y: percentLabel.center.y + circleRadius + 50)
        key.contentMode = .scaleAspectFit
        self.view.addSubview(key)
    }
    
    func createClosePopupBtn(){
        // change hard code --
        let buttonWidth = CGFloat(50)
        let buttonHeight = CGFloat(50)
        let image = UIImage(named: "Group 994") as UIImage?
        closeButton.frame = CGRect(x: whiteSquare.frame.width - 10 - buttonWidth, y: 10, width: buttonWidth, height: buttonHeight)
        closeButton.setImage(image, for: .normal)
        closeButton.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(FirstViewController.closePopup), for: UIControlEvents.touchUpInside)
        closeButton.layer.zPosition = 2
        self.whiteSquare.addSubview(closeButton)
    }
    func createHullButton(){
        // change hard code --
        let buttonWidth = CGFloat(200)
        let buttonHeight = CGFloat(70)
        
        let image = UIImage(named: "Group 995") as UIImage?
        hullButton.frame = CGRect(x: whiteSquare.frame.width/2 - buttonWidth / 2, y: whiteSquare.frame.height/2 - buttonHeight - 5, width: buttonWidth, height: buttonHeight)
        hullButton.setImage(image, for: .normal)
        hullButton.contentMode = .scaleAspectFit
        hullButton.addTarget(self, action: #selector(FirstViewController.hullPark), for: UIControlEvents.touchUpInside)
        hullButton.layer.zPosition = 3
        self.whiteSquare.addSubview(hullButton)
    }
    func createLowellButton(){
        // change hard code --
        let buttonWidth = CGFloat(200)
        let buttonHeight = CGFloat(70)
        
        let image = UIImage(named: "Group 996") as UIImage?
        lowellButton.frame = CGRect(x: whiteSquare.frame.width/2 - buttonWidth / 2, y: whiteSquare.frame.height/2 + 5, width: buttonWidth, height: buttonHeight)
        lowellButton.setImage(image, for: .normal)
        lowellButton.contentMode = .scaleAspectFit
        lowellButton.addTarget(self, action: #selector(FirstViewController.lowellPark), for: UIControlEvents.touchUpInside)
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
    // end of code for pop up screen
    
    
    func createPercentLabel(){
        let center = view.center
        let adjectedCenter = CGPoint(x: center.x, y: center.y - 30)
        let customFont = UIFont(name: "CeraRoundProDEMO-Black", size: 50)
        percentLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        percentLabel.textAlignment = .center
        percentLabel.center = adjectedCenter
        percentLabel.font = customFont
        percentLabel.text = "\(Int(totalPercent))%"
        self.view.addSubview(percentLabel)
    }
    
    func createParkButton(imageNmae: String){
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        // change hard code --
        let buttonWidth = CGFloat(430)
        let buttonHeight = CGFloat(300)
        let image = UIImage(named: imageNmae) as UIImage?
        parkButton.frame = CGRect(x: screenWidth/2 - buttonWidth/2, y: screenHeight - screenHeight/2.75, width: buttonWidth, height: buttonHeight)
        parkButton.setImage(image, for: .normal)
        parkButton.addTarget(self, action: #selector(FirstViewController.park), for: UIControlEvents.touchUpInside)
        self.view.addSubview(parkButton)
        
        
    }
    
    func createBanner(){
        let screenWidth = CGFloat(screenSize.width)
        let image: UIImage = UIImage(named: "Rectangle 6719")!
        banner = UIImageView(image: image)
        banner.frame = CGRect(x: view.center.x - screenWidth/2, y: 0, width: screenWidth, height: 120)
        self.view.addSubview(banner)
        
    }
    
    // create circle
    func createCircle(){
        circleRadius = (screenSize.width - (screenSize.width/5)) / 2
        let center = view.center
        let adjectedCenter = CGPoint(x: center.x, y: center.y - 30)
        let circlePath = UIBezierPath(arcCenter: adjectedCenter, radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: 2*CGFloat.pi, clockwise: true)
        
        // The three layers for the large center circle
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
    
    // end of UI creations
    
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
        createParkButton(imageNmae: "Group 985")
        createCircle()
        createBanner()
        createPercentLabel()
        createKey()
        createLogo()
        createSettingsButton()
        createLearnButton()
        createDashLabel()
        createStatusImg()
        
        
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.tabBarController?.tabBar.layer.shadowRadius = 7
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.1
        self.tabBarController?.tabBar.layer.masksToBounds = false
        
        
        
        // NEED TO PULL hullTakenSpots VALUE --------------------------------------------------
        // NEED TO PULL lowellTakenSpots VALUE --------------------------------------------------
        // NEED TO PULL totalPercent VALUE --------------------------
        
        
        
        
        self.ref = Database.database().reference()
        
    }
    
    // ACTIONS
    
    func animateCircles(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = lowellTotalPercent*0.8
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer2.add(basicAnimation, forKey: "urSoBasic")
        basicAnimation.toValue = hullTotalPercent*0.8
        shapeLayer .add(basicAnimation, forKey: "urSoBasic")
    }
    func calculatePercent(streetPercent: inout CGFloat, streetTotal: inout CGFloat, streetTakenSpots: inout CGFloat, comingOrGoing: CGFloat){
        // This is where we calsulate the total percent after someone comes or goes
        streetTakenSpots += comingOrGoing
        streetPercent = streetTakenSpots / streetTotal
        
        // NEED TO PUSH streetPercent VALUE   --------------------------------------------------
 
    }
    func calculateTotalPercent(){
        // This calculates the overall percent of spats taken
        takenSpots = hullTakenSpots + lowellTakenSpots
        percentLabel.text = "\(Int((takenSpots/totalSpots)*100))%"
    }
    func closePopupWindow(){
        createParkButton(imageNmae: "Group 985")
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
        })
    }
    var isParked = false
    var streetParkedOn = "None"
    
    // This changes the image of the park buton to leave or vis versa
    func parked(name: String, status: Bool){
        parkButton.removeFromSuperview()
        createParkButton(imageNmae: name)
        isParked = status
        
    }
    
    @objc func park() {
        // Check to see if user is parked
        if isParked == false{
            print("PARK")
            // prevents user from clicking park button before animation is complete (the white square will freeze without this)
            if canPressPark{
                // creates the pop up window
                createPopUp()
                canPressPark = false
            }
            //isParked = true
        }else{
            print("Leave")
            // Checks what street the user is on
            if streetParkedOn == "Hull"{
                // Calculates all the percentages needed
                // -1 is for subtracting from taken spots var
                calculatePercent(streetPercent: &hullTotalPercent, streetTotal: &hullTotalSpots, streetTakenSpots: &hullTakenSpots, comingOrGoing: -1)
            }else{
                calculatePercent(streetPercent: &lowellTotalPercent, streetTotal: &lowellTotalSpots, streetTakenSpots: &lowellTakenSpots, comingOrGoing: -1)
            }
            calculateTotalPercent()
            animateCircles()
            parked(name: "Group 985", status: false)
        }
    
        self.ref.child("test").childByAutoId().setValue(["name": "Toby"])
        
    }
    
    @objc func hullPark() {
        print("Hull")
        if hullTakenSpots < hullTotalSpots{
            calculatePercent(streetPercent: &hullTotalPercent, streetTotal: &hullTotalSpots, streetTakenSpots: &hullTakenSpots, comingOrGoing: 1)
            animateCircles()
            closePopupWindow()
            calculateTotalPercent()
            parked(name: "Group 998", status: true)
            streetParkedOn = "Hull"
        }
    }
    
    @objc func lowellPark() {
        print("Lowell")
        if lowellTakenSpots < lowellTotalSpots{
            calculatePercent(streetPercent: &lowellTotalPercent, streetTotal: &lowellTotalSpots, streetTakenSpots: &lowellTakenSpots, comingOrGoing: 1)
            animateCircles()
            closePopupWindow()
            calculateTotalPercent()
            parked(name: "Group 998", status: true)
            streetParkedOn = "Lowell"
        }
    }
    
    @objc func closePopup() {
        print("close")
        closePopupWindow()
    }
    
    @objc func goToSettings() {
        print("Settings")
        
    }
    
    @objc func goToHowto() {
        print("Howto")
        
    }
    
    
    
    
    
}
