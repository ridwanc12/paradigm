//
//  SettingsViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 2/16/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBAction func logoutTapped(_ sender: Any) {
        // When the logout button is tapped
        
    }
    
    @IBAction func deleteAccountTapped(_ sender: UIButton) {
        // When the delete account button is tapped
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
