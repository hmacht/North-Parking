//
//  SecondViewController.swift
//  North Parking
//
//  Created by Henry Macht on 9/18/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var closed = UIImageView()
    
    func createClosed(){
        let center = view.center
        let image: UIImage = UIImage(named: "Group 1244")!
        closed = UIImageView(image: image)
        closed.frame = CGRect(x: 0, y: 0, width: 200, height: 500)
        closed.center = CGPoint(x: center.x, y: center.y)
        closed.contentMode = .scaleAspectFit
        self.view.addSubview(closed)
    }
    var freshLaunch = true
    override func viewWillAppear(_ animated: Bool) {
        if freshLaunch == true {
            freshLaunch = false
            self.tabBarController?.selectedIndex = 1 // 2nd tab
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarController?.selectedIndex = 1
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        createClosed()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.tabBarController?.tabBar.layer.shadowRadius = 7
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.1
        self.tabBarController?.tabBar.layer.masksToBounds = false
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

