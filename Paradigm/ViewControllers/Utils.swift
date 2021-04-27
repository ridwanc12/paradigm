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
