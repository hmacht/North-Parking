//
//  CreditsViewController.swift
//  North Parking
//
//  Created by Henry Macht on 10/9/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    
    var creditsList = UIImageView()
    var closeButton = UIButton()
    let screenSize = UIScreen.main.bounds
    
    func createCredits(){
        let center = view.center
        let image: UIImage = UIImage(named: "Group 1249")!
        creditsList = UIImageView(image: image)
        creditsList.frame = CGRect(x: 0, y: 0, width: 200, height: 500)
        creditsList.center = CGPoint(x: center.x, y: center.y)
        creditsList.contentMode = .scaleAspectFit
        self.view.addSubview(creditsList)
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
        createCredits()
        createCloseButton()
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
