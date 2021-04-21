//
//  RemindersViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 4/16/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class RemindersViewController: UIViewController {

    @IBOutlet weak var timeTextField: UITextField!
    
    // Date/Time Picker
    private var timePicker: UIDatePicker?
    var reminderTime = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Creating a Time Formatter
        let time = Date()

        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        
        // Set the text field as the time
        timeTextField.text = formatter.string(from: time)
        
        // Creating a tool bar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        
        // Assign the toolbar
        timeTextField.inputAccessoryView = toolbar
        
        // Creating a Time Picker
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = UIDatePicker.Mode.time

        // Set the date picker to the text field
        timePicker?.frame.size = CGSize(width: 0, height: 250)
        timeTextField.inputView = timePicker
        
    }
    
    // Function called by the time picker
    @objc func timeChanged(sender: UIDatePicker) {
       // When the time is changed it will appear here
        
        timeTextField.text = formatter.string(from: sender.date)

    }
    
    // Function when the done button on the toolbar is pressed
    @objc func doneTapped() {
        
        timeTextField.text = formatter.string(from: timePicker?.date ?? Date())
        self.view.endEditing(true)

    }
    
    @IBAction func setReminderTapped(_ sender: Any) {
        // When the set reminder button is tapped
        reminderTime = timePicker?.date ?? Date()
        let timeString = formatter.string(from: reminderTime)
        print(timeString)
        let colonIndex = timeString.index(timeString.startIndex, offsetBy: 1)
        let minIndex = timeString.index(timeString.startIndex, offsetBy: 3)
        let updatedHr = timeString[...colonIndex]
        let updatedMin = timeString[minIndex...]
        // update stored time for notification
        UserDefaults.standard.set(Int(updatedHr), forKey: "notificationHr")
        UserDefaults.standard.set(Int(updatedMin), forKey: "notificationMin")
        
        // remove notification at old time and create new one with updated time
        if (UserDefaults.standard.object(forKey: "notificationsOn") == nil ||
            UserDefaults.standard.object(forKey: "notificationsOn") as! Bool) {
            Utils.turnOffNotifications()
            Utils.turnOnNotification()
            print("notification time updated")
        }

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
