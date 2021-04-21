//
//  HomeViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/16/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for permission to send notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                    NSLog("granted: \(granted)")
                    if let error = error {
                        NSLog("error: \(error)")
                    }
                })
        // Set content for notificaiton
        let content = UNMutableNotificationContent()
        content.title = "Paradigm"
        content.body = "How was your day?"
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        //dateComponents.weekday = 6    // 1 is Sunday, 7 is Saturday
        dateComponents.hour = 16        // 24 hour format
        dateComponents.minute = 57      // minute of hour
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
            print("Error")
           }
        }
        print("Notification set")
        
        // Do any additional setup after loading the view.
        // Customizing the Tab Bar
        UITabBar.appearance().tintColor = .black
//        UITabBar.appearance().barTintColor
        
        
        //obtain user data from userdefaults -- MAY NEED TO COMMENT OUT FOR FIRST TIME RUNNING IF DEFAULT IS SET TO LOGGED IN
        Utils.global_userID = UserDefaults.standard.object(forKey: "userID") as! String
        Utils.global_email = UserDefaults.standard.object(forKey: "email") as! String
        Utils.global_firstName = UserDefaults.standard.object(forKey: "firstName") as! String
        Utils.global_lastName = UserDefaults.standard.object(forKey: "lastName") as! String
        
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
