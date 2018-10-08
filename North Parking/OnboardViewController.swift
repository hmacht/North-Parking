//
//  OnboardViewController.swift
//  North Parking
//
//  Created by Henry Macht on 10/8/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds
    
    var map = UIImageView()
    var welcomeLabel = UILabel()
    var descriptionLabel = UILabel()
    var beginButton = UIButton()
    
    func createMap(){
        let center = view.center
        let image: UIImage = UIImage(named: "Group 1246")!
        map = UIImageView(image: image)
        map.frame = CGRect(x: -10, y: 0, width: screenSize.width + 20, height: screenSize.height/2)
        //closed.center = CGPoint(x: center.x, y: center.y)
        map.contentMode = .scaleAspectFill
        self.view.addSubview(map)
    }
    
    func createWelcomeLabel(){
        let center = view.center
        welcomeLabel.frame = CGRect(x: screenSize.width/15, y: map.frame.height + 30, width: 300, height: 100)
        welcomeLabel.textAlignment = .left
        welcomeLabel.font = UIFont(name: "Avenir-Black", size: 31)
        welcomeLabel.textColor = .black
        welcomeLabel.text = "Welcome to \nNorth Parking"
        welcomeLabel.numberOfLines = 2
        self.view.addSubview(welcomeLabel)
    }
    
    func createDescriptionLabel(){
        let center = view.center
        descriptionLabel.frame = CGRect(x: screenSize.width/15, y: 0, width: 350, height: 80)
        descriptionLabel.center.y = welcomeLabel.center.y + welcomeLabel.frame.height/2 + descriptionLabel.frame.height/2
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont(name: "Avenir-Black", size: 13)
        descriptionLabel.textColor = UIColor(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1.0)
        descriptionLabel.text = "See how many spots are avalable on Hull and \nLowell. Check this app every morning to see \nwhen you should leave your house. All you \nhave to do is press the park button when you \narrive at school."
        descriptionLabel.numberOfLines = 5
        descriptionLabel.sizeToFit()
        self.view.addSubview(descriptionLabel)
    }
    var downShift: CGFloat = 0
    func createBeginButton(){
        let image = UIImage(named: "Group 1248") as UIImage?
        beginButton.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 100)
        print(screenSize.height)
        if screenSize.height < 700 {
            downShift = 0
        }else{
            downShift = 20
        }
        if screenSize.height < 600{
            downShift = -10
        }
        beginButton.center = CGPoint(x: view.center.x, y: descriptionLabel.center.y + descriptionLabel.frame.height/2 + beginButton.frame.height/2 + downShift)
        beginButton.setImage(image, for: .normal)
        //beginButton.contentMode = .scaleToFill
        beginButton.addTarget(self, action: #selector(OnboardViewController.startApp), for: UIControlEvents.touchUpInside)
        beginButton.layer.zPosition = 3
        self.view.addSubview(beginButton)
    }
 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        createMap()
        createWelcomeLabel()
        createDescriptionLabel()
        createBeginButton()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func startApp() {
       performSegue(withIdentifier: "startApp", sender: nil)
    }

}
