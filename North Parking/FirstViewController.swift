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

enum ParkingLocation: String {
    case Hull = "Hull"
    case Lowell = "Lowell"
}

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    // Reference to app delegate
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let screenSize = UIScreen.main.bounds
    
    // VARS
    
    // Buttons
    var parkButton = UIButton()
    var hullButton = UIButton()
    var lowellButton = UIButton()
    var closeButton = UIButton()
    var settingsButton = UIButton()
    var learnButton = UIButton()
    var closeSplashButton = UIButton()
    var menuButton = UIButton()
    var leavingPopupButton = UIButton()
    var notLeavingPopupButton = UIButton()
    
    // Layers
    let shapeLayer = CAShapeLayer()
    let shapeLayer2 = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    // Labels
    var dashboardLabel = UILabel()
    var percentLabel = UILabel()
    var filledLabel = UILabel()
    var parkedLab = UILabel()
    var titleLabel = UILabel()
    var parkPopLabel = UILabel()
    var whichStreetLabel = UILabel()
    
    // Image views
    var whiteSquare = UIImageView()
    var popUpBlackSquare = UIImageView()
    var key = UIImageView()
    var logo = UIImageView()
    var banner = UIImageView()
    var status = UIImageView()
    var popUpFrame = UIImageView()
    
    var circle = UIView()
    
    // Bools
    var canPressPark = true
    var closeSplash = false
    
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
    
    func createPopUpFrame(BgColor: String){
        let center = view.center
        let screenWidth = CGFloat(screenSize.width)
        let screenHeight = CGFloat(screenSize.height)
        let image: UIImage = UIImage(named: BgColor)!
        popUpFrame = UIImageView(image: image)
        popUpFrame.frame = CGRect(x: 0, y: 0, width: 315, height: 350)
        popUpFrame.center = CGPoint(x: center.x, y: -popUpFrame.frame.height/2)
        popUpFrame.layer.zPosition = 2
        popUpFrame.isUserInteractionEnabled = false
        self.view.addSubview(popUpFrame)
        UIView.animate(withDuration: 0.5, animations: {
            self.popUpFrame.center.y += (center.y + self.popUpFrame.frame.width/2)
        }, completion: {finished in
            self.popUpFrame.isUserInteractionEnabled = true
        })
    }
    
    func createLeavingPopupButton(){
        let image = UIImage(named: "Group 1235") as UIImage?
        leavingPopupButton.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        leavingPopupButton.center = CGPoint(x: leavingPopupButton.frame.width/2 + 15, y: popUpFrame.frame.height - leavingPopupButton.frame.height/2 - 15)
        leavingPopupButton.setImage(image, for: .normal)
        leavingPopupButton.contentMode = .scaleAspectFit
        leavingPopupButton.addTarget(self, action: #selector(FirstViewController.leave), for: UIControlEvents.touchUpInside)
        self.popUpFrame.addSubview(leavingPopupButton)
    }
    func createNotLeavingPopupButton(){
        let image = UIImage(named: "Group 1236") as UIImage?
        notLeavingPopupButton.frame = CGRect(x: 0, y: 0, width: 70, height: 60)
        notLeavingPopupButton.center = CGPoint(x: popUpFrame.frame.width - notLeavingPopupButton.frame.width/2 - 15, y: popUpFrame.frame.height - notLeavingPopupButton.frame.height/2 - 15)
        notLeavingPopupButton.setImage(image, for: .normal)
        notLeavingPopupButton.contentMode = .scaleAspectFit
        notLeavingPopupButton.addTarget(self, action: #selector(FirstViewController.closeCenterPopUp), for: UIControlEvents.touchUpInside)
        self.popUpFrame.addSubview(notLeavingPopupButton)
    }
    
    var leavingLab = UILabel()
    var leavingDetailLab = UILabel()
    
    func createLeavingLabel(){
        let center = view.center
        leavingLab.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        leavingLab.textAlignment = .left
        leavingLab.center = CGPoint(x: 180 , y: leavingLab.frame.height/2 + 20)
        print(screenSize.width/2)
        print(center.x)
        leavingLab.font = UIFont(name: "Avenir-Black", size: 36)
        leavingLab.textColor = .black
        leavingLab.text = "Are you\nLeaving?"
        leavingLab.numberOfLines = 2
        leavingLab.sizeToFit()
        self.popUpFrame.addSubview(leavingLab)
    }
    
    func createLeavingDetailLabel(){
        let center = view.center
        leavingDetailLab.frame = CGRect(x: 0, y: 0, width: 250, height: 80)
        leavingDetailLab.textAlignment = .left
        leavingDetailLab.center = CGPoint(x: popUpFrame.frame.width/2, y: leavingLab.center.y + leavingLab.frame.height/2 + leavingDetailLab.frame.height/2 + 20)
        leavingDetailLab.font = UIFont(name: "Avenir-Black", size: 13)
        leavingDetailLab.textColor = UIColor(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1.0)
        leavingDetailLab.text = "If you are leaving, have a nice day and \nthanks for using the app. Dont forget \nto hit the park button when you come \nback ✌️️"
        leavingDetailLab.numberOfLines = 4
        leavingDetailLab.sizeToFit()
        self.popUpFrame.addSubview(leavingDetailLab)
    }
    
    func creatCenterPopUpBox(){
        self.tabBarController?.tabBar.layer.zPosition = -1
        parkButton.isUserInteractionEnabled = false
        createBlackBackground()
        createPopUpFrame(BgColor: "Rectangle 6841")
        createLeavingPopupButton()
        createNotLeavingPopupButton()
        createLeavingLabel()
        createLeavingDetailLabel()
    }
    
    func createTitle(){
        let center = view.center
        if screenSize.height < 800 {
            titleLabel.frame = CGRect(x: screenSize.width/15, y: 20, width: 200, height: 100)
        }else{
            titleLabel.frame = CGRect(x: screenSize.width/15, y: 50, width: 200, height: 100)
        }
        
        titleLabel.textAlignment = .left
        //titleLabel.center = CGPoint(x: center.x - screenSize.width/4, y: 100)
        titleLabel.font = UIFont(name: "Avenir-Black", size: 31)
        titleLabel.textColor = .black
        titleLabel.text = "Hello, 👋 \nTime To Park"
        titleLabel.numberOfLines = 2
        self.view.addSubview(titleLabel)
    }
    
    func createMenuButton(){
        let image = UIImage(named: "Group 1166") as UIImage?
        menuButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        menuButton.center = CGPoint(x: screenSize.width - menuButton.frame.width/2, y: titleLabel.center.y - 20)
        menuButton.setImage(image, for: .normal)
        menuButton.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action: #selector(FirstViewController.toMenu), for: UIControlEvents.touchUpInside)
        self.view.addSubview(menuButton)
    }
    
    func createKey(){
        let center = view.center
        let image: UIImage = UIImage(named: "Group 1222")!
        key = UIImageView(image: image)
        key.frame = CGRect(x: titleLabel.frame.minX , y: titleLabel.frame.maxY, width: 130, height: 30)
        print(titleLabel.frame.minX)
        //key.center = CGPoint(x: center.x, y: percentLabel.center.y + circleRadius + 50)
        key.contentMode = .scaleAspectFit
        self.view.addSubview(key)
    }
    
    func createCloseSplashBtn(){
        let image = UIImage(named: "Group 1116") as UIImage?
        closeSplashButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        closeSplashButton.center = CGPoint(x: view.center.x, y: view.center.y + screenSize.height / 3)
        closeSplashButton.setImage(image, for: .normal)
        closeSplashButton.contentMode = .scaleAspectFit
        closeSplashButton.addTarget(self, action: #selector(FirstViewController.closeSplashScreen), for: UIControlEvents.touchUpInside)
        closeSplashButton.layer.zPosition = 21
        self.view.addSubview(closeSplashButton)
    }
    
    func createParkedLab(){
        let center = view.center
        let customFont = UIFont(name: "CeraRoundProDEMO-Black", size: 45)
        parkedLab.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        parkedLab.textAlignment = .center
        parkedLab.center = center
        parkedLab.font = customFont
        parkedLab.textColor = .white
        parkedLab.text = "Parked!"
        parkedLab.layer.zPosition = 21
        self.view.addSubview(parkedLab)
        
    }
    
    func createSplash(){
        let circleRect = CGRect(x: view.center.x, y: view.center.y, width: 100, height: 100)
        circle = UIView(frame: circleRect)
        circle.backgroundColor = UIColor(red: 86.0/255.0, green: 106.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        circle.center = view.center
        circle.layer.cornerRadius = 50
        circle.layer.borderColor = UIColor.clear.cgColor
        circle.layer.zPosition = 20
        view.addSubview(circle)
        closeSplash = true
        UIView.animate(withDuration: 0.5, animations: {
            self.circle.frame.size = CGSize(width: self.screenSize.height * 1.2, height: self.screenSize.height * 1.2)
            self.circle.center = self.view.center
            self.circle.layer.cornerRadius = self.circle.frame.size.height / 2
        }, completion: {finished in
            self.createParkedLab()
            self.createCloseSplashBtn()
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                UIView.setAnimationRepeatCount(1)
                self.parkedLab.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                //self.closeSplashButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: {completion in
                UIView.animate(withDuration: 0.5, animations: {
                    self.parkedLab.transform = CGAffineTransform(scaleX: 1, y: 1)
                    //self.closeSplashButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
                
            })
            
        })
    }
    
    func createFillLabel(){
        let center = view.center
        let customFont = UIFont(name: "CeraRoundProDEMO-Black", size: 20)
        filledLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        filledLabel.textAlignment = .center
        filledLabel.center = CGPoint(x: percentLabel.center.x, y: percentLabel.center.y + 40)
        filledLabel.font = customFont
        filledLabel.textColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        filledLabel.text = "Filled"
        self.view.addSubview(filledLabel)
    }
    /*
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
    */
    func createParkPopLabel(){
        let center = view.center
        parkPopLabel.frame = CGRect(x: 35, y: 30, width: 400, height: 400)
        parkPopLabel.textAlignment = .left
        //parkPopLabel.center = CGPoint(x: center.x - screenSize.width/4, y: 100)
        parkPopLabel.font = UIFont(name: "Avenir-Black", size: 39)
        parkPopLabel.textColor = UIColor(red: 35.0/255.0, green: 51.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        parkPopLabel.text = "Where are \nyou parking?"
        parkPopLabel.numberOfLines = 2
        let attributedString = NSMutableAttributedString(string: "Where are \nyou parking?")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        parkPopLabel.attributedText = attributedString
        parkPopLabel.sizeToFit()
        self.whiteSquare.addSubview(parkPopLabel)
    }
    
    func createwhichStreetLabel(){
        let center = view.center
        whichStreetLabel.frame = CGRect(x: 30, y: parkPopLabel.center.y + parkPopLabel.frame.height/2 + 5, width: 200, height: 100)
        whichStreetLabel.textAlignment = .left
        //parkPopLabel.center = CGPoint(x: center.x - screenSize.width/4, y: 100)
        whichStreetLabel.font = UIFont(name: "Avenir-Black", size: 15)
        whichStreetLabel.textColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        whichStreetLabel.text = "Park responsibly :)"
        whichStreetLabel.sizeToFit()
        self.whiteSquare.addSubview(whichStreetLabel)
    }
    
    func createClosePopupBtn(){
        // change hard code --
        let buttonWidth = CGFloat(100)
        let buttonHeight = CGFloat(100)
        let image = UIImage(named: "Group 1223") as UIImage?
        closeButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        closeButton.center = CGPoint(x: view.center.x, y: lowellButton.center.y + lowellButton.frame.height + 10)
        closeButton.setImage(image, for: .normal)
        closeButton.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(FirstViewController.closePopup), for: UIControlEvents.touchUpInside)
        closeButton.layer.zPosition = 2
        self.whiteSquare.addSubview(closeButton)
    }
    func createHullButton(){
        // change hard code --
        let buttonWidth = CGFloat(250)
        let buttonHeight = CGFloat(70)
        
        let image = UIImage(named: "Group 995") as UIImage?
        hullButton.frame = CGRect(x: whiteSquare.frame.width/2 - buttonWidth / 2, y: whiteSquare.frame.height/2 - buttonHeight + 30, width: buttonWidth, height: buttonHeight)
        hullButton.setImage(image, for: .normal)
        hullButton.contentMode = .scaleAspectFit
        hullButton.addTarget(self, action: #selector(FirstViewController.hullPark), for: UIControlEvents.touchUpInside)
        hullButton.layer.zPosition = 3
        self.whiteSquare.addSubview(hullButton)
    }
    func createLowellButton(){
        // change hard code --
        let buttonWidth = CGFloat(250)
        let buttonHeight = CGFloat(70)
        
        let image = UIImage(named: "Group 996") as UIImage?
        lowellButton.frame = CGRect(x: whiteSquare.frame.width/2 - buttonWidth / 2, y: whiteSquare.frame.height/2 + 40, width: buttonWidth, height: buttonHeight)
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
        let image: UIImage = UIImage(named: "Rectangle 6841")!
        whiteSquare = UIImageView(image: image)
        print("-----------\(screenHeight / 1.8)")
        whiteSquare.frame = CGRect(x: center.x - (screenWidth - 10)/2, y: screenHeight, width: screenWidth - 10, height: 451)
        whiteSquare.layer.zPosition = 2
        whiteSquare.isUserInteractionEnabled = false
        self.view.addSubview(whiteSquare)
        UIView.animate(withDuration: 0.5, animations: {
            self.whiteSquare.frame.origin.y -= (451 + 5)
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
        createParkPopLabel()
        createwhichStreetLabel()
    }
    // end of code for pop up screen
    
    
    func createPercentLabel(){
        let center = view.center
        let adjectedCenter = CGPoint(x: center.x, y: center.y - 10)
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
        let buttonWidth = CGFloat(250)
        let buttonHeight = CGFloat(100)
        let image = UIImage(named: imageNmae) as UIImage?
        let max = screenHeight - (self.tabBarController?.tabBar.frame.height)!
        let min = (view.center.y - 10) + circleRadius
        // finds midpoint between bottom of circle and top of tab bar
        let midpoint = (min + max) / 2
        parkButton.frame = CGRect(x: screenWidth/2 - buttonWidth/2, y: screenHeight - screenHeight/3.75, width: buttonWidth, height: buttonHeight)
        parkButton.center = CGPoint(x: view.center.x, y: midpoint)
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
        let adjectedCenter = CGPoint(x: center.x, y: center.y - 10)
        let circlePath = UIBezierPath(arcCenter: adjectedCenter, radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: 2*CGFloat.pi, clockwise: true)
        // The three layers for the large center circle
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 251.0/255.0, alpha: 1.0).cgColor
        trackLayer.lineWidth = 20
        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor(red: 116.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
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
    var isWithinRange = false
    // called to pulll gps data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("managing location")
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let coordinate1 = CLLocation(latitude: 42.345262, longitude: -71.207241)
        let coordinate2 = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
        print(distanceInMeters)
        if distanceInMeters <= 600{
            print("Within Range")
            isWithinRange = true
        }else{
            print("Out of range")
            isWithinRange = false
        }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        locationSetup()
        createCircle()
        createParkButton(imageNmae: "Group 1127")
        //createBanner()
        createPercentLabel()
        //createLogo()
        //createSettingsButton()
        //createLearnButton()
        //createDashLabel()
        //createStatusImg()
        createFillLabel()
        createTitle()
        createMenuButton()
        createKey()
        
        // Add shadow to tab bar
        
        /*
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.tabBarController?.tabBar.layer.shadowRadius = 7
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.1
        self.tabBarController?.tabBar.layer.masksToBounds = false
        */
        
        
        // NEED TO PULL hullTakenSpots VALUE --------------------------------------------------
        // NEED TO PULL lowellTakenSpots VALUE --------------------------------------------------
        // NEED TO PULL totalPercent VALUE --------------------------
        
        
        
        
        self.ref = Database.database().reference()
        
        // To get numbers for a parking spot
        // Can change to .Lowell to get values for Lowell
        self.getSpotsFromServer(location: .Hull) { (n) in
            print(n, "spots in hull")
            self.hullTakenSpots = CGFloat(n)
            self.calculateTotalPercent()
            
            print(self.hullTakenSpots)
            // IMPORTANT
            // If updating UI in this closure
            // Must use
            //DispatchQueue.main.async {
            self.animateCircles()
            //}
            // And run code in that to upate any UI
            // This is because you are reaching server in background thread, and cant update ui in background
        }
        
        self.getSpotsFromServer(location: .Lowell) { (n) in
            print(n, "spots in lowell")
            self.lowellTakenSpots = CGFloat(n)
            self.calculateTotalPercent()
            
            print(self.lowellTakenSpots)
            // IMPORTANT
            // If updating UI in this closure
            // Must use
            //DispatchQueue.main.async {
            
            
            // Very important that each val is 0
            self.runCircles(parkedOnHull: 0, parkedOnLowell: 0)
            
            
            //}
            // And run code in that to upate any UI
            // This is because you are reaching server in background thread, and cant update ui in background
        }
        /*
        // For updating spots, write to server
        self.updateSpots(location: .Hull) { (error) in
            if let e = error {
                // There was an error
            }
        }
        */
        
        if UserDefaults.standard.bool(forKey: "isParked") {
            // We are already parked so change button
            self.parked(name: "Group 1180", status: true)
        }
        
    }
    
    // ACTIONS
    
    func animateCircles(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = lowellTotalPercent*0.8
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer2.add(basicAnimation, forKey: "urSoBasic")
        print(hullTotalPercent)
        basicAnimation.toValue = hullTotalPercent*0.8
        shapeLayer .add(basicAnimation, forKey: "urSoBasic")
    }
    func calculatePercent(streetPercent: inout CGFloat, streetTotal: inout CGFloat, streetTakenSpots: inout CGFloat, comingOrGoing: CGFloat){
        // This is where we calsulate the total percent after someone comes or goes
        streetTakenSpots += comingOrGoing
        streetPercent = streetTakenSpots / streetTotal
    }
    func calculateTotalPercent(){
        // This calculates the overall percent of spats taken
        takenSpots = hullTakenSpots + lowellTakenSpots
        percentLabel.text = "\(Int((takenSpots/totalSpots)*100))%"
    }
    
    func closePopupWindow(showTabBar: Bool){
        if !isParked {
            createParkButton(imageNmae: "Group 1127")
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.whiteSquare.frame.origin.y += (451 + 5)
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
        
        UserDefaults.standard.set(status, forKey: "isParked")
        
    }
    
    @objc func park() {
        
        // Send test notification
        //print("Send test notification")
        //appDelegate?.scheduleNotification()
        
        if isWithinRange{
            
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
                creatCenterPopUpBox()
                
            }
        }else{
            print("To Far Away")
        }
        
    }
    
    func runCircles(parkedOnHull: CGFloat, parkedOnLowell: CGFloat){
        calculatePercent(streetPercent: &hullTotalPercent, streetTotal: &hullTotalSpots, streetTakenSpots: &hullTakenSpots, comingOrGoing: parkedOnHull)
        calculatePercent(streetPercent: &lowellTotalPercent, streetTotal: &lowellTotalSpots, streetTakenSpots: &lowellTakenSpots, comingOrGoing: parkedOnLowell)
        calculateTotalPercent()
        animateCircles()
        //self.tabBarController?.tabBar.layer.zPosition = 0
        //createSplash()
    }
    
    @objc func hullPark() {
        print("Hull")
        if hullTakenSpots < hullTotalSpots{
            runCircles(parkedOnHull: 1, parkedOnLowell: 0)
            streetParkedOn = "Hull"
            parked(name: "Group 1180", status: true)
            closePopupWindow(showTabBar: false)
            self.updateSpots(adding: 1, location: .Hull) { (error) in
                if let e = error {
                    // There was an error
                }
            }
        }
    }
    
    @objc func lowellPark() {
        print("Lowell")
        if lowellTakenSpots < lowellTotalSpots{
            runCircles(parkedOnHull: 0, parkedOnLowell: 1)
            streetParkedOn = "Lowell"
            parked(name: "Group 1180", status: true)
            closePopupWindow(showTabBar: false)
            self.updateSpots(adding: 1, location: .Lowell) { (error) in
                if let e = error {
                    // There was an error
                }
            }
        }
    }
    
    @objc func closePopup() {
        print("close")
        closePopupWindow(showTabBar: true)
    }
    
    @objc func goToSettings() {
        print("Settings")
        
    }
    
    @objc func goToHowto() {
        print("Howto")
        
    }
    @objc func toMenu() {
        print("toMenu")
        performSegue(withIdentifier: "openMenu", sender: nil)
        
    }
    
    func removeCenterPopUp(){
        UIView.animate(withDuration: 0.5, animations: {
            self.popUpFrame.center.y -= (self.view.center.y + self.popUpFrame.frame.width/2)
            self.popUpBlackSquare.alpha = 0.0
        }, completion: {finished in
            self.parkButton.isUserInteractionEnabled = true
            self.popUpFrame.removeFromSuperview()
            self.popUpBlackSquare.removeFromSuperview()
            self.tabBarController?.tabBar.layer.zPosition = 0
            
        })
    }
    
    @objc func leave() {
        removeCenterPopUp()
        if streetParkedOn == "Hull"{
            // Calculates all the percentages needed
            // -1 is for subtracting from taken spots var
            calculatePercent(streetPercent: &hullTotalPercent, streetTotal: &hullTotalSpots, streetTakenSpots: &hullTakenSpots, comingOrGoing: -1)
            self.updateSpots(adding: -1, location: .Hull) { (error) in
                if let e = error {
                    // There was an error
                }
            }
        }else{
            calculatePercent(streetPercent: &lowellTotalPercent, streetTotal: &lowellTotalSpots, streetTakenSpots: &lowellTakenSpots, comingOrGoing: -1)
            self.updateSpots(adding: -1, location: .Lowell) { (error) in
                if let e = error {
                    // There was an error
                }
            }
        }
        calculateTotalPercent()
        animateCircles()
        parked(name: "Group 1127", status: false)
    }
    
    @objc func closeCenterPopUp() {
        removeCenterPopUp()
    }
    
    
    
    
    @objc func closeSplashScreen() {
        print("closeSplash")
        if closeSplash{
            print("Hi")
            circle.removeFromSuperview()
            parkedLab.removeFromSuperview()
            closeSplashButton.removeFromSuperview()
            closeSplash = false
            self.tabBarController?.tabBar.layer.zPosition = 0
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        
    }
    
    func getSpotsFromServer(location: ParkingLocation, completion: @escaping (Int) -> Void) {
        ref.child("SpotsTaken").observeSingleEvent(of: .value) { (snapshot) in
            if let v = snapshot.value as? NSDictionary {
                if let n = v[location.rawValue] as? Int {
                    completion(n)
                } else {
                    completion(0)
                }
            }
        }
    }
    
    func updateSpots(adding: Int, location: ParkingLocation, completion: @escaping(Error?) -> Void) {
        ref.child("SpotsTaken").runTransactionBlock({ (data) -> TransactionResult in
            if var v = data.value as? [String: AnyObject] {
                let spots = v[location.rawValue] as! Int
                v[location.rawValue] = spots + adding as AnyObject
                
                data.value = v
                return TransactionResult.success(withValue: data)
            }
            return TransactionResult.success(withValue: data)
        }) { (error, b, snapshot) in
            completion(error)
        }
    }
    
    
    
    
}
