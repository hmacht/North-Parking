//
//  MenuViewController.swift
//  North Parking
//
//  Created by Henry Macht on 10/5/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds
    
    var ring = UIImageView()
    var settings = UIButton()
    var credits = UIButton()
    var contact = UIButton()
    var closeButton = UIButton()
    let customFont = UIFont(name: "CeraRoundProDEMO-Black", size: 41)
    
    func createRing(){
        let center = view.center
        let image: UIImage = UIImage(named: "Group 1232")!
        ring = UIImageView(image: image)
        ring.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        ring.center = CGPoint(x: 90, y: screenSize.height - 60)
        ring.contentMode = .scaleAspectFit
        self.view.addSubview(ring)
    }
    
    func createSettingsButton(){
        settings.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        settings.center = CGPoint(x: view.center.x - screenSize.width/10, y: screenSize.height/3)
        settings.setTitle("Settings", for: .normal)
        settings.titleLabel?.font =  customFont
        settings.setTitleColor(.black, for: .normal)
        settings.contentMode = .scaleAspectFit
        settings.addTarget(self, action: #selector(MenuViewController.toSettings), for: UIControlEvents.touchUpInside)
        settings.contentHorizontalAlignment = .left
        self.view.addSubview(settings)
    }
    
    func createCreditsButton(){
        credits.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        credits.center = CGPoint(x: view.center.x - screenSize.width/10, y: settings.center.y + 75)
        credits.setTitle("Credits", for: .normal)
        credits.titleLabel?.font =  customFont
        credits.setTitleColor(.black, for: .normal)
        credits.contentMode = .scaleAspectFit
        credits.addTarget(self, action: #selector(MenuViewController.toCredits), for: UIControlEvents.touchUpInside)
        credits.contentHorizontalAlignment = .left
        self.view.addSubview(credits)
    }
    
    func createContactButton(){
        contact.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        contact.center = CGPoint(x: view.center.x - screenSize.width/10, y: credits.center.y + 75)
        contact.setTitle("Help", for: .normal)
        contact.titleLabel?.font =  customFont
        contact.setTitleColor(.black, for: .normal)
        contact.contentMode = .scaleAspectFit
        contact.addTarget(self, action: #selector(MenuViewController.toContact), for: UIControlEvents.touchUpInside)
        contact.contentHorizontalAlignment = .left
        self.view.addSubview(contact)
    }
    
    func createCloseButton(){
        let image = UIImage(named: "Group 1190") as UIImage?
        closeButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        closeButton.center = CGPoint(x: screenSize.width - closeButton.frame.width, y: 50)
        closeButton.setImage(image, for: .normal)
        closeButton.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(MenuViewController.close), for: UIControlEvents.touchUpInside)
        self.view.addSubview(closeButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        createRing()
        createSettingsButton()
        createCreditsButton()
        createContactButton()
        createCloseButton()
        // Do any additional setup after loading the view.
    }
    
    @objc func toSettings() {
        
        print("Settings")
        let alertController = UIAlertController (title: "Go to Settings", message: "Would you like to view the setting for this app? Doing so will take you out of the app and into your settings.", preferredStyle: .actionSheet)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func toCredits() {
        print("Credits")
        performSegue(withIdentifier: "toCredits", sender: nil)
    }
    
    @objc func toContact() {
        performSegue(withIdentifier: "showHelp", sender: nil)
    }
    
    @objc func close() {
        print("Close")
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
