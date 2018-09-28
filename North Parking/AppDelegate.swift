//
//  AppDelegate.swift
//  North Parking
//
//  Created by Henry Macht on 9/18/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Request permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authorized:Bool, error:Error?) in
            if !authorized {
                // Handle situation
                print("App is useless because you did not allow notifications.")
            }
        }
        
        // Define Actions
        let hullAction = UNNotificationAction(identifier: "hull", title: "Parked on Hull", options: [])
        let lowellAction = UNNotificationAction(identifier: "lowell", title: "Parked on Lowell", options: [])
        
        
        // Add actions to a foodCategeroy
        let category = UNNotificationCategory(identifier: "parkingCategory", actions: [hullAction, lowellAction], intentIdentifiers: [], options: [])
        
        // Add the foodCategory to Notification Framwork
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    
    func scheduleNotification() {
        
        UNUserNotificationCenter.current().delegate = self
        
        // Trigger notification in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Park"
        content.body = "Have you parked your car?"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "parkingCategory"
        
        guard let path = Bundle.main.path(forResource: "ParkImage", ofType: "png") else {return}
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "img", url: url, options: nil)
            content.attachments = [attachment]
        }catch{
            print("The attachment could not be loaded")
        }
        
        let request = UNNotificationRequest(identifier: "parkingNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        if response.actionIdentifier == "hull" {
            print("park hull")
            NetworkHelper.instance.updateSpots(location: .Hull) { (error) in
                if let e = error {
                    // TODO- handle error
                }
            }
        }else{ // Vegetable
            print("park lowell")
            NetworkHelper.instance.updateSpots(location: .Lowell) { (error) in
                if let e = error {
                    // TODO- handle error
                }
            }
        }
        
        completionHandler()
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }


}

