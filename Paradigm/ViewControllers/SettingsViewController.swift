//
//  SettingsViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/16/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBAction func switchClicked(_ sender: Any) {
        if notificationSwitch.isOn {
            // Turn on Notifications
            print("Notification switch is On")
            // Set content for notificaiton
            let content = UNMutableNotificationContent()
            content.title = "Paradigm"
            content.body = "How was your day?"
            
            // Configure the recurring date.
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current

            //dateComponents.weekday = 6    // 1 is Sunday, 7 is Saturday
            dateComponents.hour = 17        // 24 hour format
            dateComponents.minute = 01      // minute of hour
               
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
        }
        else {
            // Turn off Notifications
            print("Notification switch is Off")
        }
    }
    @IBAction func logoutTapped(_ sender: Any) {
        // When the logout button is tapped
        
        // Ask for an alert
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout of your account?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in
            // Log out the user
            // Setting the User Defaults to false
            UserDefaults.standard.set(false, forKey: "status")
            
            // After user has successfully logged out
      
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(identifier: "LoginViewController")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginView)
        }))
        
        alert.addAction(UIAlertAction( title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }

    
    @IBAction func deleteAccountTapped(_ sender: UIButton) {
        // When the delete account button is tapped
        // Add a comment
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"

        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
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
