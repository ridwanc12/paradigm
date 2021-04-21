//
//  Utils.swift
//  Paradigm
//
//  Created by Domenic Conversa on 2/23/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit
import Foundation

class Utils {

    static var global_userID = "0"
    static var global_email = "..."
    static var global_firstName = "firstName"
    static var global_lastName = "lastName"
    
    public static func notificationInit() {
        // Ask for permission to send notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                    NSLog("granted: \(granted)")
                    if let error = error {
                        NSLog("error: \(error)")
                    }
                })
        // Set content for notificaiton
        let content = UNMutableNotificationContent()
        content.title = "Journal Reminder"
        content.body = "Don't forget to record your short journal today!"
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        //dateComponents.weekday = 6    // 1 is Sunday, 7 is Saturday
        dateComponents.hour = 19        // 24 hour format
        dateComponents.minute = 47      // minute of hour
           
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
    
}



func timeLabeler(label: inout String, date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en-US")
    dateFormatter.setLocalizedDateFormatFromTemplate("EEEE MMM d yyyy")
    
    label = ""
    label += dateFormatter.string(from: date)
    
    dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
    label += " at " + dateFormatter.string(from: date)
}
